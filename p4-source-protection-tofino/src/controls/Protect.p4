control Protect(inout header_t hdr,
            in ingress_intrinsic_metadata_t ig_intr_md,
            inout ingress_metadata_t ig_md) {

    Register<protect_counter, bit<1>>(1024) primary_counter; 
    Register<bit<1>, bit<1>>(1024) active; // stores which IF is active, for hard switch

    action set_period(protect_counter period) {
        ig_md.period = period;
    }

    table period {
        key = {
            hdr.ethernet.src_addr: ternary;
        }
        actions = {
            set_period;
        } 
    }

    action set_ports(PortId_t primary, PortId_t secondary) {
      ig_md.primary = primary;
      ig_md.secondary = secondary;
    }

    table port_config {
      key = {
          hdr.ethernet.src_addr: ternary;
      }
      actions = {
          set_ports;
      }
    }

    RegisterAction<protect_counter, bit<1>,bit<1>>(primary_counter) reset_counter = {
        void apply(inout protect_counter value, out bit<1> read_value) {
            value = 0;
            read_value = 1;
        }
    };

    RegisterAction<protect_counter, bit<1>, bit<1>>(primary_counter)  update_counter = {
        void apply(inout protect_counter value, out bit<1> read_value) {
            value = value + 1;

            if(value >= ig_md.period) {
              read_value = 1;
            }
            else {
                read_value = 0;
            }
        }
    };

    RegisterAction<bit<1>, bit<1>, bit<1>>(active) set_active = {
       void apply(inout bit<1> value, out bit<1> read_value) {
           value = 0;
           read_value = 0;
       }
    };

    RegisterAction<bit<1>, bit<1>, bit<1>>(active) set_sec_active = {
       void apply(inout bit<1> value, out bit<1> read_value) {
           value = 1;
           read_value = 1;
       }
    };

    RegisterAction<bit<1>, bit<1>, bit<1>>(active) read_active = {
       void apply(inout bit<1> value, out bit<1> read_value) {
           value = value;
           read_value = value;
       }
    };


    apply {
        // get period from table
        period.apply();

        // load port information
        port_config.apply();

        @atomic {
            bit<1> accepted = 0;

            if(ig_intr_md.ingress_port == ig_md.primary) { // its a packet from the primary path, switch back to primary
                accepted = reset_counter.execute(0);
                @stage(3) {
                  set_active.execute(0); // primary path is active
                }
            }
            else if(ig_intr_md.ingress_port == ig_md.secondary) {
                accepted = update_counter.execute(0); 
                
                if(accepted == 1) {  // secondary path is active, hard switch
                    set_sec_active.execute(0);
                }
                else {
                    accepted = read_active.execute(0); // secondary path is active
                }
            }

            ig_md.accepted = accepted;
        }
    }
}
