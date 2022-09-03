/*-
 *   BSD LICENSE
 *
 *   Copyright(c) 2010-2015 Intel Corporation. All rights reserved.
 *   All rights reserved.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following conditions
 *   are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in
 *       the documentation and/or other materials provided with the
 *       distribution.
 *     * Neither the name of Intel Corporation nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 *   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 *   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 *   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#include <stdint.h>
#include <inttypes.h>
#include <signal.h>
#include <stdbool.h>
#include <errno.h>
/* dpdk */
#include <rte_eal.h>
#include <rte_ethdev.h>
#include <rte_cycles.h>
#include <rte_lcore.h>
#include <rte_mbuf.h>
#include <rte_timer.h>
#include <rte_errno.h>
/* librte_net */
#include <rte_ether.h>
#include <rte_ip.h>
#include <rte_udp.h>
/* dump packet contents */
#include <rte_hexdump.h>
#include <rte_malloc.h>
/* logging */
#include <rte_log.h>
/* atomic counter */
#include <rte_atomic.h>
#include "paxos.h"
#include "rte_paxos.h"
#include "const.h"
#include "utils.h"
#include "args.h"


#define BURST_TX_DRAIN_US 1 /* TX drain every ~1µs */

struct client {
    enum PAXOS_TEST test;
    struct rte_mempool *mbuf_pool;
    uint32_t cur_inst;
};

static const struct rte_eth_conf port_conf_default = {
        .rxmode = { .max_rx_pkt_len = ETHER_MAX_LEN }
};

static struct rte_timer timer;
static struct rte_timer gen_timer;

static rte_atomic32_t counter = RTE_ATOMIC32_INIT(0);

static struct rte_eth_dev_tx_buffer *tx_buffer;

static void
generate_packets(struct rte_mbuf **pkts_burst, unsigned nb_tx,
    struct rte_eth_dev_tx_buffer *buffer, enum PAXOS_TEST t, int cur_inst)
{
    uint16_t dport;
    switch(t) {
        case PROPOSER:
            dport = PROPOSER_PORT;
            break;
        case COORDINATOR:
            dport = COORDINATOR_PORT;
            break;
        case ACCEPTOR:
            dport = ACCEPTOR_PORT;
            break;
        case LEARNER:
            dport = LEARNER_PORT;
            break;
        default:
            dport = 11111;
    }

    char str[] = "Hello World";
    struct paxos_accept accept = {
        .iid = 1,
        .ballot = 1,
        .value_ballot = 1,
        .aid = 0,
        .value = {sizeof(str), str},
    };
    struct paxos_message pm;
    pm.type = (PAXOS_ACCEPT);
    pm.u.accept = accept;
	unsigned i;
	for (i = 0; i < nb_tx; i++) {
        pm.u.accept.iid = cur_inst;
        add_paxos_message(&pm, pkts_burst[i], 12345, dport);
        rte_eth_tx_buffer(0, 0, buffer, pkts_burst[i]);
        PRINT_DEBUG("submit instance %u", cur_inst);
    }
}

static int
send_packets(struct client *client, struct rte_eth_dev_tx_buffer *buffer, int nb_tx)
{
    struct rte_mbuf *bufs[nb_tx];
    rte_pktmbuf_alloc_bulk(client->mbuf_pool, bufs, nb_tx);
    generate_packets(bufs, nb_tx, buffer, client->test, client->cur_inst);
}

static void
gen_timer_callback(struct rte_timer *tim, void *arg)
{
    struct client* client = (struct client*) arg;
    send_packets(client, tx_buffer, 1);
    if (force_quit)
        rte_timer_stop(tim);
}

static int
hexdump_paxos_hdr(struct rte_mbuf *created_pkt)
{
    size_t paxos_offset = sizeof(struct ether_hdr) + sizeof(struct ipv4_hdr) +
                        sizeof(struct udp_hdr);
    struct paxos_hdr *px = rte_pktmbuf_mtod_offset(created_pkt,
                                struct paxos_hdr *, paxos_offset);
    if (rte_get_log_level() == RTE_LOG_DEBUG)
        rte_hexdump(stdout, "paxos", px, sizeof(struct paxos_hdr));
}


static uint16_t __attribute((unused))
check_return(uint8_t port __rte_unused, uint16_t qidx __rte_unused,
        struct rte_mbuf **pkts, uint16_t nb_pkts,
        uint16_t max_pkts __rte_unused, void *user_param __rte_unused)
{
    uint64_t cycles = 0;
    uint64_t now = rte_rdtsc();
    unsigned i;

    for (i = 0; i < nb_pkts; i++) {
        cycles += now - pkts[i]->udata64;
        hexdump_paxos_hdr(pkts[i]);
    }

    return nb_pkts;
};


/*
 * Initializes a given port using global settings and with the RX buffers
 * coming from the mbuf_pool passed as a parameter.
 */
static inline int
port_init(uint8_t port, struct rte_mempool *mbuf_pool)
{
    struct rte_eth_conf port_conf = port_conf_default;
    const uint16_t rx_rings = 1, tx_rings = 1;
    int retval;
    uint16_t q;
    if (port >= rte_eth_dev_count())
            return -1;
    struct rte_eth_dev_info dev_info;
    struct rte_eth_txconf *txconf;
    struct rte_eth_rxconf *rxconf;
    rte_eth_dev_info_get(port, &dev_info);

    rxconf = &dev_info.default_rxconf;
    txconf = &dev_info.default_txconf;

    txconf->txq_flags &= PKT_TX_IPV4;
    txconf->txq_flags &= PKT_TX_UDP_CKSUM;

    /* Configure the Ethernet device. */
    retval = rte_eth_dev_configure(port, rx_rings, tx_rings, &port_conf);
    if (retval != 0)
            return retval;
    /* Allocate and set up 1 RX queue per Ethernet port. */
    for (q = 0; q < rx_rings; q++) {
            retval = rte_eth_rx_queue_setup(port, q, RX_RING_SIZE,
                            rte_eth_dev_socket_id(port), rxconf, mbuf_pool);
            if (retval < 0)
                    return retval;
    }
    /* Allocate and set up 1 TX queue per Ethernet port. */
    for (q = 0; q < tx_rings; q++) {
            retval = rte_eth_tx_queue_setup(port, q, TX_RING_SIZE,
                            rte_eth_dev_socket_id(port), txconf);
            if (retval < 0)
                return retval;
    }

    /* Start the Ethernet port. */
    retval = rte_eth_dev_start(port);
    if (retval < 0)
            return retval;
    /* Enable RX in promiscuous mode for the Ethernet device. */
    rte_eth_promiscuous_enable(port);

    rte_eth_add_rx_callback(port, 0, check_return, NULL);

    return 0;
}
/*
 * The lcore main. This is the main thread that does the work, reading from
 * an input port and writing to an output port.
 */
static void
lcore_main(uint8_t port)
{
    struct rte_mbuf *pkts_burst[BURST_SIZE];
    uint64_t prev_tsc, diff_tsc, cur_tsc;
    unsigned i, nb_rx;
    const uint64_t drain_tsc = (rte_get_tsc_hz() + US_PER_S - 1) / US_PER_S *
            BURST_TX_DRAIN_US;

    prev_tsc = 0;

    /* Run until the application is quit or killed. */
    while (!force_quit) {
        cur_tsc = rte_rdtsc();
        /* TX burst queue drain */
        diff_tsc = cur_tsc - prev_tsc;
        if (unlikely(diff_tsc > drain_tsc)) {
            rte_eth_tx_buffer_flush(port, 0, tx_buffer);
        }

        prev_tsc = cur_tsc;

        nb_rx = rte_eth_rx_burst(port, 0, pkts_burst, BURST_SIZE);
        rte_atomic32_add(&counter, nb_rx);
        /* Free packets. */
        for (i = 0; i < nb_rx; i++)
            rte_pktmbuf_free(pkts_burst[i]);
    }
}

static void
report_stat(struct rte_timer *tim, void *arg)
{
    int *period = (int *)arg;
    PRINT_DEBUG("%s on core %d", __func__, rte_lcore_id());
    int count = rte_atomic32_read(&counter);
    PRINT_INFO("%8d", count / *period);
    rte_atomic32_set(&counter, 0);
	if (force_quit)
		rte_timer_stop(tim);
}

/*
 * The main function, which does initialization and calls the per-lcore
 * functions.
 */
int
main(int argc, char *argv[])
{
    struct rte_eth_dev_info dev_info;
    unsigned lcore_id;
    uint8_t portid = 0;
	force_quit = false;

    /* Learner's instance starts at 1 */
    /* Initialize the Environment Abstraction Layer (EAL). */
    int ret = rte_eal_init(argc, argv);
    if (ret < 0)
        rte_exit(EXIT_FAILURE, "Error with EAL initialization\n");

    argc -= ret;
    argv += ret;

    parse_args(argc, argv);

    struct client client;
    client.test = client_config.test;
    client.cur_inst = 1;

    rte_timer_init(&timer);
    rte_timer_init(&gen_timer);
    uint64_t hz = rte_get_timer_hz();

    rte_eth_dev_info_get(portid, &dev_info);
    /* increase call frequency to rte_timer_manage() to increase the precision */
    TIMER_RESOLUTION_CYCLES = hz / 100;
    PRINT_INFO("1 cycle is %3.2f ns", 1E9 / (double)hz);

	signal(SIGINT, signal_handler);
	signal(SIGTERM, signal_handler);

    /* Creates a new mempool in memory to hold the mbufs. */
    client.mbuf_pool = rte_pktmbuf_pool_create("MBUF_POOL", NUM_MBUFS,
            MBUF_CACHE_SIZE, 0, RTE_MBUF_DEFAULT_BUF_SIZE, rte_socket_id());
    if (client.mbuf_pool == NULL)
            rte_exit(EXIT_FAILURE, "Cannot create mbuf pool\n");

    tx_buffer = rte_zmalloc_socket("tx_buffer",
                RTE_ETH_TX_BUFFER_SIZE(BURST_SIZE), 0,
                rte_eth_dev_socket_id(portid));
    if (tx_buffer == NULL)
        rte_exit(EXIT_FAILURE, "Cannot allocate buffer for tx on port %u\n",
                (unsigned) portid);

    rte_eth_tx_buffer_init(tx_buffer, BURST_SIZE);

    /* Initialize port 0. */
    if (port_init(portid, client.mbuf_pool) != 0)
            rte_exit(EXIT_FAILURE, "Cannot init port %"PRIu8 "\n", portid);

    /* display stats every period seconds */
    lcore_id = rte_get_next_lcore(rte_lcore_id(), 0, 1);
    int period = client_config.period;
    rte_timer_reset(&timer, period*hz, PERIODICAL, lcore_id, report_stat, &period);
    rte_eal_remote_launch(check_timer_expiration, NULL, lcore_id);

    lcore_id = rte_get_next_lcore(rte_lcore_id(), 0, 1);
    rte_timer_reset(&gen_timer, period*hz, PERIODICAL, lcore_id,
                        gen_timer_callback, &client);
    rte_eal_remote_launch(check_timer_expiration, NULL, lcore_id);

	rte_timer_subsystem_init();

    /* Call lcore_main on the master core only. */
    lcore_main(portid);
    return 0;
}
