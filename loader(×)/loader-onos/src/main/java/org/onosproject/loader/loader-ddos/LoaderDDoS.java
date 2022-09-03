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

package org.onosproject.p4tutorial.mytunnel;

import com.google.common.collect.Lists;
import com.google.common.graph.MutableGraph;
import org.apache.felix.scr.annotations.Activate;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Deactivate;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.ReferenceCardinality;

import org.jgrapht.alg.interfaces.SpanningTreeAlgorithm;
import org.jgrapht.alg.spanning.PrimMinimumSpanningTree;
import org.jgrapht.graph.DefaultEdge;
import org.jgrapht.graph.DefaultWeightedEdge;
import org.jgrapht.graph.SimpleGraph;
import org.jgrapht.graph.SimpleWeightedGraph;
import org.onlab.graph.Graph;
import org.onlab.graph.ScalarWeight;
import org.onlab.packet.IpAddress;
import org.onlab.util.ImmutableByteSequence;
import org.onosproject.core.ApplicationId;
import org.onosproject.core.CoreService;
import org.onosproject.net.Device;
import org.onosproject.net.DeviceId;
import org.onosproject.net.EdgeLink;
import org.onosproject.net.Host;
import org.onosproject.net.Link;
import org.onosproject.net.Path;
import org.onosproject.net.PortNumber;
import org.onosproject.net.device.PortStatistics;
import org.onosproject.net.device.PortStatisticsDiscovery;
import org.onosproject.net.driver.DriverData;
import org.onosproject.net.driver.DriverHandler;
import org.onosproject.net.flow.DefaultFlowRule;
import org.onosproject.net.flow.DefaultTrafficSelector;
import org.onosproject.net.flow.DefaultTrafficTreatment;
import org.onosproject.net.flow.FlowRule;
import org.onosproject.net.flow.FlowRuleService;
import org.onosproject.net.flow.criteria.PiCriterion;
import org.onosproject.net.host.HostEvent;
import org.onosproject.net.host.HostListener;
import org.onosproject.net.host.HostService;
import org.onosproject.net.pi.model.PiActionId;
import org.onosproject.net.pi.model.PiActionParamId;
import org.onosproject.net.pi.model.PiMatchFieldId;
import org.onosproject.net.pi.model.PiTableId;
import org.onosproject.net.pi.runtime.PiAction;
import org.onosproject.net.pi.runtime.PiActionParam;
//import org.onosproject.net.statistic.impl.StatisticManager;
import org.onosproject.net.topology.DefaultTopologyEdge;
import org.onosproject.net.topology.Topology;
import org.onosproject.net.topology.TopologyService;
import org.slf4j.Logger;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Random;
import java.util.Set;
import java.util.stream.Collectors;

import static org.slf4j.LoggerFactory.getLogger;


@Component(immediate = true)
public class MyTunnelApp {
    
    private static final String APP_NAME = "org.onosproject.p4tutorial.mytunnel";
    private static final String FORWARDING_TABLE_NAME = "c_ingress.ipv4ForwardingTable";
    private static final String MONITORING_TABLE_NAME = "c_ingress.monitorHH";
    private static final String DIFFSERV_RESTORATION_TABLE_NAME = "c_egress.restoreDiffserv";
    private static final int FLOW_RULE_PRIORITY = 100;
    private final HostListener hostListener = new InternalHostListener();
    private ApplicationId appId;
    private static final Logger log = getLogger(MyTunnelApp.class);
    private static final int MAX_NUM_HOSTS = 5;
    private static final int MAX_NUM_REPLICAS = 3;

    private HashMap<DeviceId, Double> centralityMap = new HashMap<>();
    private HashMap<DeviceId, Integer> replicasIds = new HashMap<>();
    private List<ConnectivityPair> connectivityList = new ArrayList<>();
    private List<DeviceId> replicasPosition = new ArrayList<>();
    private Map<DeviceId, Integer> mcPorts = new HashMap<>();

    @Reference(cardinality = ReferenceCardinality.MANDATORY_UNARY)
    private FlowRuleService flowRuleService;

    @Reference(cardinality = ReferenceCardinality.MANDATORY_UNARY)
    private CoreService coreService;

    @Reference(cardinality = ReferenceCardinality.MANDATORY_UNARY)
    private TopologyService topologyService;

    @Reference(cardinality = ReferenceCardinality.MANDATORY_UNARY)
    private HostService hostService;

    //@Reference(cardinality = ReferenceCardinality.MANDATORY_UNARY)
    //private StatisticManager statisticManager;


    @Activate
    public void activate() {
        log.info("Starting...");
        appId = coreService.registerApplication(APP_NAME);
        hostService.addListener(hostListener);
        log.info("LODGE APP STARTED", appId.id());

    }

    @Deactivate
    public void deactivate() {
        log.info("Stopping...");
        hostService.removeListener(hostListener);
        flowRuleService.removeFlowRulesById(appId);
        log.info("LODGE APP STOPPED");
    }


    private void insertPiFlowRule(DeviceId switchId, PiTableId tableId,
                                  PiCriterion piCriterion, PiAction piAction) {
        FlowRule rule = DefaultFlowRule.builder()
                .forDevice(switchId)
                .forTable(tableId)
                .fromApp(appId)
                .withPriority(FLOW_RULE_PRIORITY)
                .makePermanent()
                .withSelector(DefaultTrafficSelector.builder()
                                      .matchPi(piCriterion).build())
                .withTreatment(DefaultTrafficTreatment.builder()
                                       .piTableAction(piAction).build())
                .build();
        flowRuleService.applyFlowRules(rule);
    }

    private void insertDefaultPiFlowRule(DeviceId switchId, PiTableId tableId, PiAction piAction) {
        FlowRule rule = DefaultFlowRule.builder()
                .forDevice(switchId)
                .forTable(tableId)
                .fromApp(appId)
                .withPriority(FLOW_RULE_PRIORITY)
                .makePermanent()
                .withTreatment(DefaultTrafficTreatment.builder()
                                       .piTableAction(piAction).build())
                .build();
        flowRuleService.applyFlowRules(rule);
    }

    private Path pickRandomPath(Set<Path> paths) {
        int item = new Random().nextInt(paths.size());
        List<Path> pathList = Lists.newArrayList(paths);
        
        return pathList.get(item);
    }

    private void updateDeviceCentrality(DeviceId sw){
            if(centralityMap.containsKey(sw))
                centralityMap.replace(sw, centralityMap.get(sw) + 1);
            else
                centralityMap.put(sw, new Double(1));
            log.info("Centrality of " + sw.toString() + " : " + centralityMap.get(sw));
    }

    private void insertL3ForwardingRule(DeviceId sw, PortNumber port, IpAddress dstIp){
        updateDeviceCentrality(sw);
        PiTableId forwardingTableId = PiTableId.of(FORWARDING_TABLE_NAME);
        PiMatchFieldId ipDestMatchFieldId = PiMatchFieldId.of("hdr.ipv4.dstAddr");
        PiCriterion match = PiCriterion.builder()
                .matchLpm(ipDestMatchFieldId, dstIp.toOctets(), 32)
                .build();

        PiActionId forwardingActionId = PiActionId.of("c_ingress.set_egress");
        PiActionParam forwardingActionParam = new PiActionParam(PiActionParamId.of("newEgress"), ImmutableByteSequence.copyFrom(port.toLong()));

        PiAction action = PiAction.builder()
                .withId(forwardingActionId)
                .withParameter(forwardingActionParam)
                .build();
        
        //log.info("Inserting INGRESS rule on switch {}: table={}, match={}, action={}", sw, forwardingTableId, match, action);

        insertPiFlowRule(sw, forwardingTableId, match, action);

    }

    private void insertLodgeForwardingRule(DeviceId sw, Integer mcGroup){
        PiTableId forwardingTableId = PiTableId.of("c_ingress.forwardLodgeTable");
        PiMatchFieldId lodgeStateIdField = PiMatchFieldId.of("hdr.lodge.stateID");

        PiCriterion match = PiCriterion.builder()
                .matchExact(lodgeStateIdField, 1)
                .build();

        PiActionId forwardingActionId = PiActionId.of("c_ingress.set_multicast_egress");
        PiActionParam forwardingActionParam = new PiActionParam(PiActionParamId.of("newEgress"), ImmutableByteSequence.copyFrom(mcGroup));
        PiActionParam replicaId = new PiActionParam(PiActionParamId.of("thisReplicaId"), replicasIds.get(sw));
        PiAction action = PiAction.builder()
                .withId(forwardingActionId)
                .withParameter(forwardingActionParam)
                .withParameter(replicaId)
                .build();

        insertPiFlowRule(sw, forwardingTableId, match, action);

        log.info("Inserting LODGE_FORWARDING rule on switch {}: table={}, match={}, action={}", sw, forwardingTableId, match, action);

    }

    private void insertDiffServRestorationRule(DeviceId sw, PortNumber port){

        PiTableId diffservRestorationTableId = PiTableId.of(DIFFSERV_RESTORATION_TABLE_NAME);
        PiMatchFieldId egressPort = PiMatchFieldId.of("standard_metadata.egress_port");
        PiCriterion match = PiCriterion.builder()
                .matchExact(egressPort, port.toLong())
                .build();

        PiActionId restorationActionId = PiActionId.of("c_egress.restore_diffserv");

        PiAction action = PiAction.builder()
                .withId(restorationActionId)
                .build();

        insertPiFlowRule(sw, diffservRestorationTableId, match, action);

    }
    /*
        Get shortest paths from src host and dst host and creates appropriate rules inside switches.
     */
    private List<Link> setL3Forwarding(Host srcHost, Host dstHost, Topology topo){
        DeviceId srcSwitch = srcHost.location().deviceId();
        DeviceId dstSwitch = dstHost.location().deviceId();

        List<Link> pathLinks = Collections.emptyList();

        if (srcSwitch.equals(dstSwitch)) {
            for(IpAddress dstIp : dstHost.ipAddresses())
                insertL3ForwardingRule(dstHost.location().deviceId(), dstHost.location().port(), dstIp);

        } else {
            Set<Path> allPaths = topologyService.getPaths(topo, srcSwitch, dstSwitch);
            if (allPaths.size() == 0) {
                log.warn("No paths between {} and {}", srcHost.id(), dstHost.id());
                return Collections.emptyList();
            }
            pathLinks = allPaths.iterator().next().links();

            for (IpAddress dstIpAddr : dstHost.ipAddresses()) {
                for (Link link : pathLinks) {
                    DeviceId sw = link.src().deviceId();
                    PortNumber port = link.src().port();
                    insertL3ForwardingRule(sw, port, dstIpAddr);
                }
                insertL3ForwardingRule(dstHost.location().deviceId(), dstHost.location().port(), dstIpAddr);
            }
        }
        return pathLinks;
    }

    private void selectPositionOfReplicasInsideTopology(Topology topo){
        List<DeviceId> sortedDevices = centralityMap.entrySet().stream()
                .sorted(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());
        sortedDevices= Lists.reverse(sortedDevices);

        int numReplicasPlaced = 0;
        for(DeviceId did : sortedDevices) {
            log.info("Placing a replica inside device " + did.toString() + " with centrality " + centralityMap.get(did).doubleValue());
            placeHHRuleInsideTopology(did);
            replicasPosition.add(did);
            replicasIds.put(did, numReplicasPlaced);
            if(++numReplicasPlaced == MAX_NUM_REPLICAS) break;
        }
    }

    private void placeHHRuleInsideTopology(DeviceId sw){
        PiTableId forwardingTableId = PiTableId.of(MONITORING_TABLE_NAME);
        PiMatchFieldId ipDestMatchFieldId = PiMatchFieldId.of("hdr.ipv4.dstAddr");
        PiCriterion match = PiCriterion.builder()
                .matchLpm(ipDestMatchFieldId, IpAddress.valueOf("10.0.0.0").toOctets(), 24)
                .build();

        PiActionId forwardingActionId = PiActionId.of("c_ingress.update_local_state");

        PiAction action = PiAction.builder()
                .withId(forwardingActionId)
                .build();

        insertPiFlowRule(sw, forwardingTableId, match, action);
    }

    private boolean isConnectivityPresent(Host s, Host d){
        for(ConnectivityPair cp : connectivityList){
            if( cp.equals(new ConnectivityPair(s,d, null)) ){
                return true;
            }
        }
        return false;
    }


    protected void placeLodgeFillingRule(){
        PiTableId cloningTableId = PiTableId.of("c_ingress.fillLodgeHeaderTable");
        PiActionId fillingActionId = PiActionId.of("c_ingress.fillLodgeHeader");

        for(DeviceId did : replicasIds.keySet()) {
            PiActionParam replicaIdParam = new PiActionParam(PiActionParamId.of("thisReplicaId"), ImmutableByteSequence.copyFrom(replicasIds.get(did)));

            PiAction action = PiAction.builder()
                    .withParameter(replicaIdParam)
                    .withId(fillingActionId)
                    .build();

            insertDefaultPiFlowRule(did, cloningTableId, action);
        }
    }



    private void createDistributionTree(Topology topo){
        org.jgrapht.Graph<DeviceId, DefaultWeightedEdge> g = new SimpleWeightedGraph<>(DefaultWeightedEdge.class);

        for(DeviceId did : replicasPosition)
            g.addVertex(did);

        for (DeviceId s : replicasPosition) {
            for (DeviceId d : replicasPosition) {
                if (s.equals(d)) continue; // avoid self edges
                if ( g.containsEdge(d,s) ||  g.containsEdge(s,d)) continue; // avoid douplicate edges
                g.addEdge(s,d);

                int w = topologyService.getPaths(topo, s, d).iterator().next().links().size();
                ((SimpleWeightedGraph<DeviceId, DefaultWeightedEdge>) g).setEdgeWeight(g.getEdge(s,d), w);
            }
        }
        SpanningTreeAlgorithm.SpanningTree<DefaultWeightedEdge> st = new PrimMinimumSpanningTree(g).getSpanningTree();

        g.edgeSet().forEach(e-> log.info("Edges: " + e.toString() + "with weight " + g.getEdgeWeight(e)));
        st.getEdges().forEach(e -> log.info("Edges of MST " + e.toString()));

        org.jgrapht.Graph<DeviceId, DefaultWeightedEdge> gmst = (SimpleWeightedGraph<DeviceId, DefaultWeightedEdge>) ((SimpleWeightedGraph<DeviceId, DefaultWeightedEdge>) g).clone();

        g.edgeSet().forEach(e ->{
            if(!st.getEdges().contains(e))
                gmst.removeEdge(e);
        });

        gmst.edgeSet().forEach(e-> log.info("Edges of final MST: " + e.toString() + "with weight " + g.getEdgeWeight(e)));

        for(DefaultWeightedEdge e : gmst.edgeSet()){
            DeviceId sid = gmst.getEdgeSource(e);
            DeviceId did = gmst.getEdgeTarget(e);
            createMCGroup(sid, did, topo);
            createMCGroup(did, sid, topo);
        }

        mcPorts.forEach((k, v)-> log.info("MC tree: " + k.toString() + " mc_grp " + v));
        mcPorts.forEach((k, v)-> insertLodgeForwardingRule(k,v));
    }

    private void createMCGroup(DeviceId sid, DeviceId did, Topology topo){
        Path sp = topologyService.getPaths(topo, sid, did).iterator().next();

        for(Link l : sp.links()){
            if( !mcPorts.containsKey(l.src().deviceId())) mcPorts.put(l.src().deviceId(), 0);

            mcPorts.put(l.src().deviceId(), mcPorts.get(l.src().deviceId()) + (int) Math.pow(2, l.src().port().toLong()-1));
        }
    }

    private void checkForwardingToReplicas(Topology topo) {
        for(ConnectivityPair cp : connectivityList){
            List<Link> sp = cp.sp;
            if(pathContainsReplica(sp)) continue;

            findShortestPathPassingFromReplica(cp.s, cp.d);
        }
    }

    private void setForwardingToReplicas(DeviceId sw, PortNumber port, IpAddress dstIp){
        PiTableId forwardingTableId = PiTableId.of("c_ingress.forwardToNearestReplica");
        PiMatchFieldId ipDestMatchFieldId = PiMatchFieldId.of("hdr.ipv4.dstAddr");
        PiCriterion match = PiCriterion.builder()
                .matchLpm(ipDestMatchFieldId, dstIp.toOctets(), 32)
                .build();

        PiActionId forwardingActionId = PiActionId.of("c_ingress.set_egress");
        PiActionParam forwardingActionParam = new PiActionParam(PiActionParamId.of("newEgress"), ImmutableByteSequence.copyFrom(port.toLong()));

        PiAction action = PiAction.builder()
                .withId(forwardingActionId)
                .withParameter(forwardingActionParam)
                .build();

        //log.info("Inserting INGRESS rule on switch {}: table={}, match={}, action={}", sw, forwardingTableId, match, action);

        insertPiFlowRule(sw, forwardingTableId, match, action);
    }

    private void findShortestPathPassingFromReplica(Host s, Host d){
        List<Link> shortestPathToReplica = Collections.emptyList();
        List<Link> shortestPathFromReplica = Collections.emptyList();

        for (DeviceId did : replicasPosition ){
            List<Link> pathToReplica = topologyService.getPaths(topologyService.currentTopology(), s.location().deviceId() , did).iterator().next().links();
            List<Link> pathFromReplica = topologyService.getPaths(topologyService.currentTopology(), did , d.location().deviceId()).iterator().next().links();
            if( (pathFromReplica.size() + pathFromReplica.size()) < (shortestPathToReplica.size() + shortestPathFromReplica.size()) || (shortestPathToReplica.size() + shortestPathFromReplica.size()) == 0){
                shortestPathToReplica = pathToReplica;
                shortestPathFromReplica = pathFromReplica;
            }
        }

        for(Link l : shortestPathToReplica){
            for(IpAddress ip : d.ipAddresses())
                setForwardingToReplicas(l.src().deviceId(), l.dst().port(), ip);
        }

        for(Link l : shortestPathFromReplica){
            for(IpAddress ip : d.ipAddresses())
                insertL3ForwardingRule(l.src().deviceId(), l.dst().port(), ip);
        }

    }

    private boolean pathContainsReplica(List<Link> sp){
        for(Link l : sp){
            if(replicasIds.get(l.src().deviceId()) != null || replicasIds.get(l.dst().deviceId()) != null)
                return true;
        }
        return false;
    }

    private class InternalHostListener implements HostListener {
        @Override
        public void event(HostEvent event) {

            //log.info("Catched a host event from host {}", event.subject().ipAddresses());
            for (Host otherHost : hostService.getHosts()) {
                log.info("Host " + otherHost.ipAddresses().toString() + " connected to switch " + otherHost.location().deviceId() + " via port" + otherHost.location().port());
            }
            if (event.type() != HostEvent.Type.HOST_ADDED)  return;

            synchronized (this) {
                Host host = event.subject();
                //insertDiffServRestorationRule(host.location().deviceId(), host.location().port());

                Topology topo = topologyService.currentTopology();
                List<Link> sp;
                for (Host otherHost : hostService.getHosts()) {
                    if (!host.equals(otherHost) ) {
                        if(!isConnectivityPresent(host, otherHost)) {
                            sp = setL3Forwarding(host, otherHost, topo);
                            connectivityList.add(new ConnectivityPair(host, otherHost, sp));
                        }
                        if(!isConnectivityPresent(otherHost, host)) {
                            sp = setL3Forwarding(otherHost, host, topo);
                            connectivityList.add(new ConnectivityPair(otherHost, host, sp));
                        }
                    }
                }
            }

            if(hostService.getHostCount() == MAX_NUM_HOSTS){

                for(Host h : hostService.getHosts()){
                    insertDiffServRestorationRule(h.location().deviceId(), h.location().port());
                }

                selectPositionOfReplicasInsideTopology(topologyService.currentTopology());
                createDistributionTree(topologyService.currentTopology());
                placeLodgeFillingRule();
                checkForwardingToReplicas(topologyService.currentTopology());

            }

        }

    }


    public class ConnectivityPair {
        public Host s;
        public Host d;
        public List<Link> sp;

        public ConnectivityPair(Host s, Host d, List<Link> sp) {
            this.s = s;
            this.d = d;
            this.sp = sp;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) {
                return true;
            }
            if (!(o instanceof ConnectivityPair)) {
                return false;
            }
            ConnectivityPair that = (ConnectivityPair) o;
            return Objects.equals(s, that.s) &&
                    Objects.equals(d, that.d);
        }

        @Override
        public int hashCode() {

            return Objects.hash(s, d);
        }
    }


}
