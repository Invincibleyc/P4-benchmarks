# HyPer4 Tools

## EvalRun

This tool accepts the run number as a command line parameter and assumes there exist two pcap files named 'run<run #>-<iface>.pcap'.  It associates packets between the two pcap files and measures the latency between each pair.  From this list of latencies, it produces a PDF, CDF, and percentile chart.
