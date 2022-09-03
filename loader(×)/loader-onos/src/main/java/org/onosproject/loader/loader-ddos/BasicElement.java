//package org.onosproject.p4tutorial.mytunnel;


import org.onosproject.net.DeviceId;

public class BasicElement {

    public class State {
        private final DeviceId target;
        private final main.java.org.onosproject.p4tutorial.mytunnel.StateScope scope;


        public State(DeviceId target, StateScope scope) {
            this.target = target;
            this.scope = scope;
        }

        public State(StateScope scope) {
            this.scope = scope;
        }

    }

    public class Reduction {

    }

    public class Activity {

    }

    public class Trigger {

    }
}