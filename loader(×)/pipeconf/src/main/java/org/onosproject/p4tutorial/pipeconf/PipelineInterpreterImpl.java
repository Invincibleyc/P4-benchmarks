/*
 * Copyright 2017-present Open Networking Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.onosproject.p4tutorial.pipeconf;

import com.google.common.collect.BiMap;
import com.google.common.collect.ImmutableBiMap;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import org.onlab.packet.DeserializationException;
import org.onlab.packet.Ethernet;
import org.onlab.util.ImmutableByteSequence;
import org.onosproject.net.ConnectPoint;
import org.onosproject.net.DeviceId;
import org.onosproject.net.Port;
import org.onosproject.net.PortNumber;
import org.onosproject.net.device.DeviceService;
import org.onosproject.net.driver.AbstractHandlerBehaviour;
import org.onosproject.net.flow.TrafficTreatment;
import org.onosproject.net.flow.criteria.Criterion;
import org.onosproject.net.flow.instructions.Instruction;
import org.onosproject.net.flow.instructions.Instructions.OutputInstruction;
import org.onosproject.net.packet.DefaultInboundPacket;
import org.onosproject.net.packet.InboundPacket;
import org.onosproject.net.packet.OutboundPacket;
import org.onosproject.net.pi.model.PiActionId;
import org.onosproject.net.pi.model.PiActionParamId;
import org.onosproject.net.pi.model.PiControlMetadataId;
import org.onosproject.net.pi.model.PiMatchFieldId;
import org.onosproject.net.pi.model.PiPipelineInterpreter;
import org.onosproject.net.pi.model.PiTableId;
import org.onosproject.net.pi.runtime.PiAction;
import org.onosproject.net.pi.runtime.PiActionParam;
import org.onosproject.net.pi.runtime.PiControlMetadata;
import org.onosproject.net.pi.runtime.PiPacketOperation;
import org.slf4j.Logger;

import static org.slf4j.LoggerFactory.getLogger;

import java.nio.ByteBuffer;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

import static java.lang.String.format;
import static org.onlab.util.ImmutableByteSequence.copyFrom;
import static org.onosproject.net.PortNumber.CONTROLLER;
import static org.onosproject.net.PortNumber.FLOOD;
import static org.onosproject.net.flow.instructions.Instruction.Type.OUTPUT;
import static org.onosproject.net.pi.model.PiPacketOperationType.PACKET_OUT;

/**
 * Implementation of a pipeline interpreter for the mytunnel.p4 program.
 */
public final class PipelineInterpreterImpl extends AbstractHandlerBehaviour implements PiPipelineInterpreter {

    // MISC
    private static final Logger log = getLogger(PipelineInterpreterImpl.class);

    private static final String DOT = ".";
    private static final int PORT_FIELD_BITWIDTH = 9;
    private static final String EGRESS_PORT = "egress_port";
    private static final String INGRESS_PORT = "ingress_port";

    // INGRESS C AND T
    private static final String C_INGRESS = "c_ingress";
    private static final String T_L3_FWD = "ipv4ForwardingTable";
    private static final String T_MONITOR_HH = "monitorHH";
    // EGRESS C AND T
    private static final String C_EGRESS = "c_egress";
    private static final String T_RESTORE_DIFFSERV = "restoreDiffserv";




    // MATCH FIELDS (KEYS)
    private static final PiMatchFieldId INGRESS_PORT_ID = PiMatchFieldId.of("standard_metadata.ingress_port");
    private static final PiMatchFieldId ETH_DST_ID = PiMatchFieldId.of("hdr.ethernet.dst_addr");
    private static final PiMatchFieldId ETH_SRC_ID = PiMatchFieldId.of("hdr.ethernet.src_addr");
    private static final PiMatchFieldId ETH_TYPE_ID = PiMatchFieldId.of("hdr.ethernet.etherType");
    private static final PiMatchFieldId IPV4_SRC_ID = PiMatchFieldId.of("hdr.ipv4.srcAddr");
    private static final PiMatchFieldId IPV4_DST_ID = PiMatchFieldId.of("hdr.ipv4.dstAddr");
    private static final PiMatchFieldId LODGE_SRC_ID = PiMatchFieldId.of("hdr.lodge.srcSwID");
    private static final PiMatchFieldId LODGE_DST_ID = PiMatchFieldId.of("hdr.lodge.dstSwID");


    // TABLES
    private static final PiTableId TABLE_L3_FWD_ID = PiTableId.of(C_INGRESS + DOT + T_L3_FWD);
    private static final PiTableId TABLE_LLDP_FW_ID = PiTableId.of(C_INGRESS + DOT + "lldpForwardingTable");
    private static final PiTableId TABLE_MONITOR_HH_ID = PiTableId.of(C_INGRESS + DOT + T_MONITOR_HH);
    //private static final PiTableId TABLE_RESTORE_DIFFSERV_ID = PiTableId.of(C_INGRESS + DOT + T_RESTORE_DIFFSERV);
    private static final BiMap<Integer, PiTableId> TABLE_MAP =
            new ImmutableBiMap.Builder<Integer, PiTableId>()
                    .put(0, TABLE_LLDP_FW_ID)
                    .put(1, TABLE_L3_FWD_ID)
                    .put(2, TABLE_MONITOR_HH_ID)
                    //.put(3, TABLE_RESTORE_DIFFSERV_ID)
                    .build();

    // ACTIONS AND ITS PARAMS
    private static final PiActionId ACT_ID_NOP = PiActionId.of("NoAction");
    private static final PiActionId ACT_ID_SEND_TO_CPU = PiActionId.of(C_INGRESS + DOT + "send_to_cpu");
    private static final PiActionId ACT_ID_SET_EGRESS_PORT = PiActionId.of(C_INGRESS + DOT + "set_egress");
    private static final PiActionId ACT_ID_DROP = PiActionId.of(C_INGRESS + DOT + "operation_drop");
    private static final PiActionId ACT_ID_READ_REMOTE_LODGE = PiActionId.of(C_INGRESS + DOT + "read_remote_lodge");
    private static final PiActionId ACT_ID_UPDATE_LOCAL_STATE = PiActionId.of(C_INGRESS + DOT + "update_local_state");
    private static final PiActionId ACT_ID_LOAD_LODGE_DATA = PiActionId.of(C_INGRESS + DOT + "load_lodge_meta");

    private static final PiActionParamId ACT_PARAM_ID_PORT = PiActionParamId.of("port");


    // MATCHES
    private static final BiMap<Criterion.Type, PiMatchFieldId> CRITERION_MAP =
            new ImmutableBiMap.Builder<Criterion.Type, PiMatchFieldId>()
                    .put(Criterion.Type.IN_PORT, INGRESS_PORT_ID)
                    .put(Criterion.Type.ETH_DST, ETH_DST_ID)
                    .put(Criterion.Type.ETH_SRC, ETH_SRC_ID)
                    .put(Criterion.Type.ETH_TYPE, ETH_TYPE_ID)
                    .put(Criterion.Type.IPV4_SRC, IPV4_SRC_ID)
                    .put(Criterion.Type.IPV4_DST, IPV4_DST_ID)
                    .build();

    @Override
    public Optional<PiMatchFieldId> mapCriterionType(Criterion.Type type) {
        return Optional.ofNullable(CRITERION_MAP.get(type));
    }

    @Override
    public Optional<Criterion.Type> mapPiMatchFieldId(PiMatchFieldId headerFieldId) {
        return Optional.ofNullable(CRITERION_MAP.inverse().get(headerFieldId));
    }

    @Override
    public Optional<PiTableId> mapFlowRuleTableId(int flowRuleTableId) {
        return Optional.ofNullable(TABLE_MAP.get(flowRuleTableId));
    }

    @Override
    public Optional<Integer> mapPiTableId(PiTableId piTableId) {
        return Optional.ofNullable(TABLE_MAP.inverse().get(piTableId));
    }

    @Override
    public PiAction mapTreatment(TrafficTreatment treatment, PiTableId piTableId)
            throws PiInterpreterException {

        if (piTableId != TABLE_LLDP_FW_ID) { throw new PiInterpreterException("Can map treatments only for 't_l2_fwd' table"); }

        if (treatment.allInstructions().size() == 0) {
            //return PiAction.builder().withId(ACT_ID_NOP).build();
            throw new PiInterpreterException("Treatment has zero instructions");
        } else if (treatment.allInstructions().size() > 1) {
            throw new PiInterpreterException("Treatment has multiple instructions");
        }

        Instruction instruction = treatment.allInstructions().get(0);

        if (instruction.type() != OUTPUT) {
            // We can map only instructions of type OUTPUT.
            throw new PiInterpreterException(format(
                    "Instruction of type '%s' not supported", instruction.type()));
        }

        OutputInstruction outInstruction = (OutputInstruction) instruction;
        PortNumber port = outInstruction.port();
        if (!port.isLogical()) {
            return PiAction.builder()
                    .withId(ACT_ID_SET_EGRESS_PORT)
                    .withParameter(new PiActionParam(
                            ACT_PARAM_ID_PORT, copyFrom(port.toLong())))
                    .build();
        } else if (port.equals(CONTROLLER)) {
            return PiAction.builder()
                    .withId(ACT_ID_SEND_TO_CPU)
                    .build();
        } else {
            log.info("MAP TREATMENT TROWING EXCEPTION!!!");
            throw new PiInterpreterException(format(
                    "Output on logical port '%s' not supported", port));
        }
    }

    @Override
    public Collection<PiPacketOperation> mapOutboundPacket(OutboundPacket packet)
            throws PiInterpreterException {

        TrafficTreatment treatment = packet.treatment();

        // We support only packet-out with OUTPUT instructions.
        if (treatment.allInstructions().size() != 1 &&
                treatment.allInstructions().get(0).type() != OUTPUT) {
            throw new PiInterpreterException(
                    "Treatment not supported: " + treatment.toString());
        }

        Instruction instruction = treatment.allInstructions().get(0);
        PortNumber port = ((OutputInstruction) instruction).port();
        List<PiPacketOperation> piPacketOps = Lists.newArrayList();

        if (!port.isLogical()) {
            piPacketOps.add(createPiPacketOp(packet.data(), port.toLong()));
        } else if (port.equals(FLOOD)) {
            // Since mytunnel.p4 does not support flooding, we create a packet
            // operation for each switch port.
            DeviceService deviceService = handler().get(DeviceService.class);
            DeviceId deviceId = packet.sendThrough();
            for (Port p : deviceService.getPorts(deviceId)) {
                piPacketOps.add(createPiPacketOp(packet.data(), p.number().toLong()));
            }
        } else {
            throw new PiInterpreterException(format(
                    "Output on logical port '%s' not supported", port));
        }
        //log.info(packet.toString() + " " + piPacketOps.get(0).toString());
        return piPacketOps;
    }

    @Override
    public InboundPacket mapInboundPacket(PiPacketOperation packetIn)
            throws PiInterpreterException {
        // We assume that the packet is ethernet, which is fine since mytunnel.p4
        // can deparse only ethernet packets.
        Ethernet ethPkt;

        try {
            ethPkt = Ethernet.deserializer().deserialize(
                    packetIn.data().asArray(), 0, packetIn.data().size());
        } catch (DeserializationException dex) {
            throw new PiInterpreterException(dex.getMessage());
        }

        // Returns the ingress port packet metadata.
        Optional<PiControlMetadata> packetMetadata = packetIn.metadatas().stream()
                .filter(metadata -> metadata.id().toString().equals(INGRESS_PORT))
                .findFirst();

        if (packetMetadata.isPresent()) {
            short s = packetMetadata.get().value().asReadOnlyBuffer().getShort();
            ConnectPoint receivedFrom = new ConnectPoint(
                    packetIn.deviceId(), PortNumber.portNumber(s));
            return new DefaultInboundPacket(
                    receivedFrom, ethPkt, packetIn.data().asReadOnlyBuffer());
        } else {
            throw new PiInterpreterException(format(
                    "Missing metadata '%s' in packet-in received from '%s': %s",
                    INGRESS_PORT, packetIn.deviceId(), packetIn));
        }
    }

    private PiPacketOperation createPiPacketOp(ByteBuffer data, long portNumber)
            throws PiInterpreterException {
        PiControlMetadata metadata = createControlMetadata(portNumber);
        return PiPacketOperation.builder()
                .forDevice(this.data().deviceId())
                .withType(PACKET_OUT)
                .withData(copyFrom(data))
                .withMetadatas(ImmutableList.of(metadata))
                .build();
    }

    private PiControlMetadata createControlMetadata(long portNumber)
            throws PiInterpreterException {
        try {
            return PiControlMetadata.builder()
                    .withId(PiControlMetadataId.of(EGRESS_PORT))
                    .withValue(copyFrom(portNumber).fit(PORT_FIELD_BITWIDTH))
                    .build();
        } catch (ImmutableByteSequence.ByteSequenceTrimException e) {
            throw new PiInterpreterException(format(
                    "Port number %d too big, %s", portNumber, e.getMessage()));
        }
    }
}
