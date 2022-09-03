
#include "p4_prefix.h"

#include <iostream>

#include <string.h>

#include "pd/pd.h"

#include <list>
#include <map>
#include <mutex>
#include <thread>
#include <condition_variable>

using namespace  ::p4_pd_rpc;
using namespace  ::res_pd_rpc;

namespace {

void bytes_meter_spec_thrift_to_pd(
    const prog_bytes_meter_spec_t &meter_spec,
    p4_pd_bytes_meter_spec_t *pd_meter_spec) {
  pd_meter_spec->cir_kbps = meter_spec.cir_kbps;
  pd_meter_spec->cburst_kbits = meter_spec.cburst_kbits;
  pd_meter_spec->pir_kbps = meter_spec.pir_kbps;
  pd_meter_spec->pburst_kbits = meter_spec.pburst_kbits;
  pd_meter_spec->meter_type = meter_spec.color_aware ?
      PD_METER_TYPE_COLOR_AWARE : PD_METER_TYPE_COLOR_UNAWARE;
}

void packets_meter_spec_thrift_to_pd(
    const prog_packets_meter_spec_t &meter_spec,
    p4_pd_packets_meter_spec_t *pd_meter_spec) {
  pd_meter_spec->cir_pps = meter_spec.cir_pps;
  pd_meter_spec->cburst_pkts = meter_spec.cburst_pkts;
  pd_meter_spec->pir_pps = meter_spec.pir_pps;
  pd_meter_spec->pburst_pkts = meter_spec.pburst_pkts;
   pd_meter_spec->meter_type = meter_spec.color_aware ?
       PD_METER_TYPE_COLOR_AWARE : PD_METER_TYPE_COLOR_UNAWARE;
}

}  // namespace


class progHandler : virtual public progIf {
private:
  class CbWrap {
    CbWrap() {}

    int wait() {
      std::unique_lock<std::mutex> lock(cb_mutex);
      while(cb_status == 0) {
        cb_condvar.wait(lock);
      }
      return 0;
    }

    void notify() {
      std::unique_lock<std::mutex> lock(cb_mutex);
      assert(cb_status == 0);
      cb_status = 1;
      cb_condvar.notify_one();
    }

    static void cb_fn(int device_id, void *cookie) {
      (void) device_id;
      CbWrap *inst = static_cast<CbWrap *>(cookie);
      inst->notify();
    }

    CbWrap(const CbWrap &other) = delete;
    CbWrap &operator=(const CbWrap &other) = delete;

    CbWrap(CbWrap &&other) = delete;
    CbWrap &operator=(CbWrap &&other) = delete;

   private:
    std::mutex cb_mutex{};
    std::condition_variable cb_condvar{};
    int cb_status{0};
  };

public:
    progHandler() {
    }

    // Table entry add functions

    EntryHandle_t dmacTable_table_add_with_add_island_header(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt, const prog_dmacTable_match_spec_t &match_spec, const prog_add_island_header_action_spec_t &action_spec) {
        std::cerr << "In dmacTable_table_add_with_add_island_header\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_dmacTable_match_spec_t pd_match_spec;
	memcpy(pd_match_spec.ethernet_dstAddr, match_spec.ethernet_dstAddr.c_str(), 6);

        p4_pd_prog_add_island_header_action_spec_t pd_action_spec;
        pd_action_spec.action_dstIsland = action_spec.action_dstIsland;
        pd_action_spec.action_srcIsland = action_spec.action_srcIsland;

        p4_pd_entry_hdl_t pd_entry;

        p4_pd_prog_dmacTable_table_add_with_add_island_header(sess_hdl, pd_dev_tgt, &pd_match_spec, &pd_action_spec, &pd_entry);
        return pd_entry;
    }

    EntryHandle_t dmacTable_table_add_with_l2_broadcast(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt, const prog_dmacTable_match_spec_t &match_spec, const prog_l2_broadcast_action_spec_t &action_spec) {
        std::cerr << "In dmacTable_table_add_with_l2_broadcast\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_dmacTable_match_spec_t pd_match_spec;
	memcpy(pd_match_spec.ethernet_dstAddr, match_spec.ethernet_dstAddr.c_str(), 6);

        p4_pd_prog_l2_broadcast_action_spec_t pd_action_spec;
        pd_action_spec.action_group = action_spec.action_group;

        p4_pd_entry_hdl_t pd_entry;

        p4_pd_prog_dmacTable_table_add_with_l2_broadcast(sess_hdl, pd_dev_tgt, &pd_match_spec, &pd_action_spec, &pd_entry);
        return pd_entry;
    }

    EntryHandle_t dmacTable_table_add_with_l2_forward(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt, const prog_dmacTable_match_spec_t &match_spec) {
        std::cerr << "In dmacTable_table_add_with_l2_forward\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_dmacTable_match_spec_t pd_match_spec;
	memcpy(pd_match_spec.ethernet_dstAddr, match_spec.ethernet_dstAddr.c_str(), 6);

        p4_pd_entry_hdl_t pd_entry;

        p4_pd_prog_dmacTable_table_add_with_l2_forward(sess_hdl, pd_dev_tgt, &pd_match_spec, &pd_entry);
        return pd_entry;
    }

    EntryHandle_t isThisIsland_table_add_with_noop(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt, const prog_isThisIsland_match_spec_t &match_spec) {
        std::cerr << "In isThisIsland_table_add_with_noop\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_isThisIsland_match_spec_t pd_match_spec;
        pd_match_spec.island_hop_dstIsland = match_spec.island_hop_dstIsland;

        p4_pd_entry_hdl_t pd_entry;

        p4_pd_prog_isThisIsland_table_add_with_noop(sess_hdl, pd_dev_tgt, &pd_match_spec, &pd_entry);
        return pd_entry;
    }

    EntryHandle_t isThisIsland_table_add_with_strip_island_header(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt, const prog_isThisIsland_match_spec_t &match_spec) {
        std::cerr << "In isThisIsland_table_add_with_strip_island_header\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_isThisIsland_match_spec_t pd_match_spec;
        pd_match_spec.island_hop_dstIsland = match_spec.island_hop_dstIsland;

        p4_pd_entry_hdl_t pd_entry;

        p4_pd_prog_isThisIsland_table_add_with_strip_island_header(sess_hdl, pd_dev_tgt, &pd_match_spec, &pd_entry);
        return pd_entry;
    }

    EntryHandle_t islandTable_table_add_with_forward_to_island(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt, const prog_islandTable_match_spec_t &match_spec, const prog_forward_to_island_action_spec_t &action_spec) {
        std::cerr << "In islandTable_table_add_with_forward_to_island\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_islandTable_match_spec_t pd_match_spec;
        pd_match_spec.island_hop_dstIsland = match_spec.island_hop_dstIsland;

        p4_pd_prog_forward_to_island_action_spec_t pd_action_spec;
        pd_action_spec.action_port = action_spec.action_port;

        p4_pd_entry_hdl_t pd_entry;

        p4_pd_prog_islandTable_table_add_with_forward_to_island(sess_hdl, pd_dev_tgt, &pd_match_spec, &pd_action_spec, &pd_entry);
        return pd_entry;
    }

    EntryHandle_t smacTable_table_add_with_send_l2_digest(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt, const prog_smacTable_match_spec_t &match_spec) {
        std::cerr << "In smacTable_table_add_with_send_l2_digest\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_smacTable_match_spec_t pd_match_spec;
	memcpy(pd_match_spec.ethernet_srcAddr, match_spec.ethernet_srcAddr.c_str(), 6);

        p4_pd_entry_hdl_t pd_entry;

        p4_pd_prog_smacTable_table_add_with_send_l2_digest(sess_hdl, pd_dev_tgt, &pd_match_spec, &pd_entry);
        return pd_entry;
    }



    // Table entry modify functions

    EntryHandle_t dmacTable_table_modify_with_add_island_header(const SessionHandle_t sess_hdl, const int8_t dev_id, const EntryHandle_t entry, const prog_add_island_header_action_spec_t &action_spec) {
        std::cerr << "In dmacTable_table_modify_with_add_island_header\n";

        p4_pd_prog_add_island_header_action_spec_t pd_action_spec;
        pd_action_spec.action_dstIsland = action_spec.action_dstIsland;
        pd_action_spec.action_srcIsland = action_spec.action_srcIsland;


        return p4_pd_prog_dmacTable_table_modify_with_add_island_header(sess_hdl, dev_id, entry, &pd_action_spec);
    }

    EntryHandle_t dmacTable_table_modify_with_l2_broadcast(const SessionHandle_t sess_hdl, const int8_t dev_id, const EntryHandle_t entry, const prog_l2_broadcast_action_spec_t &action_spec) {
        std::cerr << "In dmacTable_table_modify_with_l2_broadcast\n";

        p4_pd_prog_l2_broadcast_action_spec_t pd_action_spec;
        pd_action_spec.action_group = action_spec.action_group;


        return p4_pd_prog_dmacTable_table_modify_with_l2_broadcast(sess_hdl, dev_id, entry, &pd_action_spec);
    }

    EntryHandle_t dmacTable_table_modify_with_l2_forward(const SessionHandle_t sess_hdl, const int8_t dev_id, const EntryHandle_t entry) {
        std::cerr << "In dmacTable_table_modify_with_l2_forward\n";


        return p4_pd_prog_dmacTable_table_modify_with_l2_forward(sess_hdl, dev_id, entry);
    }

    EntryHandle_t isThisIsland_table_modify_with_noop(const SessionHandle_t sess_hdl, const int8_t dev_id, const EntryHandle_t entry) {
        std::cerr << "In isThisIsland_table_modify_with_noop\n";


        return p4_pd_prog_isThisIsland_table_modify_with_noop(sess_hdl, dev_id, entry);
    }

    EntryHandle_t isThisIsland_table_modify_with_strip_island_header(const SessionHandle_t sess_hdl, const int8_t dev_id, const EntryHandle_t entry) {
        std::cerr << "In isThisIsland_table_modify_with_strip_island_header\n";


        return p4_pd_prog_isThisIsland_table_modify_with_strip_island_header(sess_hdl, dev_id, entry);
    }

    EntryHandle_t islandTable_table_modify_with_forward_to_island(const SessionHandle_t sess_hdl, const int8_t dev_id, const EntryHandle_t entry, const prog_forward_to_island_action_spec_t &action_spec) {
        std::cerr << "In islandTable_table_modify_with_forward_to_island\n";

        p4_pd_prog_forward_to_island_action_spec_t pd_action_spec;
        pd_action_spec.action_port = action_spec.action_port;


        return p4_pd_prog_islandTable_table_modify_with_forward_to_island(sess_hdl, dev_id, entry, &pd_action_spec);
    }

    EntryHandle_t smacTable_table_modify_with_send_l2_digest(const SessionHandle_t sess_hdl, const int8_t dev_id, const EntryHandle_t entry) {
        std::cerr << "In smacTable_table_modify_with_send_l2_digest\n";


        return p4_pd_prog_smacTable_table_modify_with_send_l2_digest(sess_hdl, dev_id, entry);
    }



    // Table entry delete functions

    int32_t dmacTable_table_delete(const SessionHandle_t sess_hdl, const int8_t dev_id, const EntryHandle_t entry) {
        std::cerr << "In dmacTable_table_delete\n";

        return p4_pd_prog_dmacTable_table_delete(sess_hdl, dev_id, entry);
    }

    int32_t isThisIsland_table_delete(const SessionHandle_t sess_hdl, const int8_t dev_id, const EntryHandle_t entry) {
        std::cerr << "In isThisIsland_table_delete\n";

        return p4_pd_prog_isThisIsland_table_delete(sess_hdl, dev_id, entry);
    }

    int32_t islandTable_table_delete(const SessionHandle_t sess_hdl, const int8_t dev_id, const EntryHandle_t entry) {
        std::cerr << "In islandTable_table_delete\n";

        return p4_pd_prog_islandTable_table_delete(sess_hdl, dev_id, entry);
    }

    int32_t smacTable_table_delete(const SessionHandle_t sess_hdl, const int8_t dev_id, const EntryHandle_t entry) {
        std::cerr << "In smacTable_table_delete\n";

        return p4_pd_prog_smacTable_table_delete(sess_hdl, dev_id, entry);
    }


    // set default action

    int32_t dmacTable_set_default_action_add_island_header(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt, const prog_add_island_header_action_spec_t &action_spec) {
        std::cerr << "In dmacTable_set_default_action_add_island_header\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_add_island_header_action_spec_t pd_action_spec;
        pd_action_spec.action_dstIsland = action_spec.action_dstIsland;
        pd_action_spec.action_srcIsland = action_spec.action_srcIsland;

        p4_pd_entry_hdl_t pd_entry;

        return p4_pd_prog_dmacTable_set_default_action_add_island_header(sess_hdl, pd_dev_tgt, &pd_action_spec, &pd_entry);

        // return pd_entry;
    }

    int32_t dmacTable_set_default_action_l2_broadcast(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt, const prog_l2_broadcast_action_spec_t &action_spec) {
        std::cerr << "In dmacTable_set_default_action_l2_broadcast\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_l2_broadcast_action_spec_t pd_action_spec;
        pd_action_spec.action_group = action_spec.action_group;

        p4_pd_entry_hdl_t pd_entry;

        return p4_pd_prog_dmacTable_set_default_action_l2_broadcast(sess_hdl, pd_dev_tgt, &pd_action_spec, &pd_entry);

        // return pd_entry;
    }

    int32_t dmacTable_set_default_action_l2_forward(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt) {
        std::cerr << "In dmacTable_set_default_action_l2_forward\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_entry_hdl_t pd_entry;

        return p4_pd_prog_dmacTable_set_default_action_l2_forward(sess_hdl, pd_dev_tgt, &pd_entry);

        // return pd_entry;
    }

    int32_t isThisIsland_set_default_action_noop(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt) {
        std::cerr << "In isThisIsland_set_default_action_noop\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_entry_hdl_t pd_entry;

        return p4_pd_prog_isThisIsland_set_default_action_noop(sess_hdl, pd_dev_tgt, &pd_entry);

        // return pd_entry;
    }

    int32_t isThisIsland_set_default_action_strip_island_header(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt) {
        std::cerr << "In isThisIsland_set_default_action_strip_island_header\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_entry_hdl_t pd_entry;

        return p4_pd_prog_isThisIsland_set_default_action_strip_island_header(sess_hdl, pd_dev_tgt, &pd_entry);

        // return pd_entry;
    }

    int32_t islandTable_set_default_action_forward_to_island(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt, const prog_forward_to_island_action_spec_t &action_spec) {
        std::cerr << "In islandTable_set_default_action_forward_to_island\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_forward_to_island_action_spec_t pd_action_spec;
        pd_action_spec.action_port = action_spec.action_port;

        p4_pd_entry_hdl_t pd_entry;

        return p4_pd_prog_islandTable_set_default_action_forward_to_island(sess_hdl, pd_dev_tgt, &pd_action_spec, &pd_entry);

        // return pd_entry;
    }

    int32_t smacTable_set_default_action_send_l2_digest(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt) {
        std::cerr << "In smacTable_set_default_action_send_l2_digest\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_entry_hdl_t pd_entry;

        return p4_pd_prog_smacTable_set_default_action_send_l2_digest(sess_hdl, pd_dev_tgt, &pd_entry);

        // return pd_entry;
    }


    // clear default action

    void dmacTable_table_reset_default_entry(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt) {
        std::cerr << "In dmacTable_table_reset_default_entry\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_dmacTable_table_reset_default_entry(sess_hdl, pd_dev_tgt);
    }

    void isThisIsland_table_reset_default_entry(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt) {
        std::cerr << "In isThisIsland_table_reset_default_entry\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_isThisIsland_table_reset_default_entry(sess_hdl, pd_dev_tgt);
    }

    void islandTable_table_reset_default_entry(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt) {
        std::cerr << "In islandTable_table_reset_default_entry\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_islandTable_table_reset_default_entry(sess_hdl, pd_dev_tgt);
    }

    void smacTable_table_reset_default_entry(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt) {
        std::cerr << "In smacTable_table_reset_default_entry\n";

        p4_pd_dev_target_t pd_dev_tgt;
        pd_dev_tgt.device_id = dev_tgt.dev_id;
        pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

        p4_pd_prog_smacTable_table_reset_default_entry(sess_hdl, pd_dev_tgt);
    }



  int32_t clean_all(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt) {
      std::cerr << "In clean_all\n";

      p4_pd_dev_target_t pd_dev_tgt;
      pd_dev_tgt.device_id = dev_tgt.dev_id;
      pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

      return p4_pd_prog_clean_all(sess_hdl, pd_dev_tgt);
  }

  int32_t tables_clean_all(const SessionHandle_t sess_hdl, const DevTarget_t &dev_tgt) {
      std::cerr << "In tables_clean_all\n";

      p4_pd_dev_target_t pd_dev_tgt;
      pd_dev_tgt.device_id = dev_tgt.dev_id;
      pd_dev_tgt.dev_pipe_id = dev_tgt.dev_pipe_id;

      assert(0);

      return 0;
  }

    // INDIRECT ACTION DATA AND MATCH SELECT




    int32_t dmacTable_get_entry_count(const SessionHandle_t sess_hdl, const int8_t dev_id) {
        uint32_t count = 0;

        int status = p4_pd_prog_dmacTable_get_entry_count(sess_hdl, dev_id, &count);
        if(status != 0) return -1;
        return static_cast<int32_t>(count);
    }

    int32_t isThisIsland_get_entry_count(const SessionHandle_t sess_hdl, const int8_t dev_id) {
        uint32_t count = 0;

        int status = p4_pd_prog_isThisIsland_get_entry_count(sess_hdl, dev_id, &count);
        if(status != 0) return -1;
        return static_cast<int32_t>(count);
    }

    int32_t islandTable_get_entry_count(const SessionHandle_t sess_hdl, const int8_t dev_id) {
        uint32_t count = 0;

        int status = p4_pd_prog_islandTable_get_entry_count(sess_hdl, dev_id, &count);
        if(status != 0) return -1;
        return static_cast<int32_t>(count);
    }

    int32_t smacTable_get_entry_count(const SessionHandle_t sess_hdl, const int8_t dev_id) {
        uint32_t count = 0;

        int status = p4_pd_prog_smacTable_get_entry_count(sess_hdl, dev_id, &count);
        if(status != 0) return -1;
        return static_cast<int32_t>(count);
    }


    // COUNTERS



  // METERS


  // REGISTERS


  void set_learning_timeout(const SessionHandle_t sess_hdl, const int8_t dev_id, const int32_t msecs) {
      p4_pd_prog_set_learning_timeout(sess_hdl, (const uint8_t)dev_id, msecs);
  }

};
