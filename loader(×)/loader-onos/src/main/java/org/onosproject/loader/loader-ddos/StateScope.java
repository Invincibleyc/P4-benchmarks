//package org.onosproject.p4tutorial.mytunnel;

public class StateScope {
    public class Rate extends StateScope {
        private final NetObject filter;


        public Rate(NetObject filter) {
            this.filter = filter;
        }

    }
}