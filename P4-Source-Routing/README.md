# P4 Source Routing project

The code used to gather performance measurements for paper 'Using P4 and Source Based Routing to Enable Performant Intents in Software Defined Networks'

### Vagrant Box
Vagrant box is based on Ubuntu 16.04 Bento box and will build snapshot versions of the P4 toolchain used for the results published.

Navigate to the vagrant directory and run `vagrant up`, note that the build can take some time.

To run the experiments, navigate to the `run` directory and run `veth_setup.sh num` where num is the number of veth pairs to create to use with the behavioral model.

To run the experiment, use ```python benchmark_runs.py iterations min_switches max_switches increments```, replacing the arguments as necessary
For example, ```python benchmark_runs.py 10, 50, 100, 10``` will run for 50, 60 70, 80, 90 and 100 switches 10 times.

Results are written to a text file in the run directory with a timestamp and the number of switches.
