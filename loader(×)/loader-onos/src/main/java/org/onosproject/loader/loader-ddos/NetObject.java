//package org.onosproject.p4tutorial.mytunnel;

import org.onlab.packet.IpAddress;
import org.onosproject.net.DeviceId;

public class NetObject {

    public class Packet extends NetObject {
        private final IpAddress srcIP;
        private final IpAddress dstIP;
        private final int srcPort;
        private final int dstPort;
        private final int l4Proto;

        public Packet(IpAddress srcIP, IpAddress dstIP, int srcPort, int dstPort, int l4Proto) {
            this.srcIP = srcIP;
            this.dstIP = dstIP;
            this.srcPort = srcPort;
            this.dstPort = dstPort;
            this.l4Proto = l4Proto;
        }

        public String getMatchRule(){
            return "";
        }

    }

    public class Port extends NetObject {
        private final DeviceId deviceId;
        private final int portIndex;

        public Port(DeviceId deviceId, int portIndex) {
            this.deviceId = deviceId;
            this.portIndex = portIndex;
        }

        public String getMatchRule(){
            return "";
        }
    }

}