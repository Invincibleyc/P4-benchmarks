package main.java.org.onosproject.p4tutorial.mytunnel;

//import main.java.org.onosproject.p4tutorial.mytunnel.*;
import org.onlab.packet.IpAddress;




public class DDoSApp {
    private List<State> states;
    private Reduction reduction;
    private Activity activity;
    private Trigger trigger;

    public void initializeApp(){
        Packet externalTraffic = new Packet(IpAddress(), dstIP, srcPort, dstPort, l4Proto);
        StateScope incomingRateMonitor = new Rate();
        State s = new State(scope);
    }
}