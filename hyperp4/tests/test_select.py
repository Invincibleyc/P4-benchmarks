#!/usr/bin/python

# David Hancock
# Flux Research Group
# University of Utah

import os
import subprocess

import sys
from p4_mininet import P4Switch, P4Host

from hp4controller.clients.client import ChainSliceManager as HP4ClientSliceManager
from hp4controller.clients.client import Administrator as HP4ClientAdmin

from mininet.net import Mininet
from mininet.topo import Topo
from mininet.log import setLogLevel, info
from mininet.cli import CLI
from mininet.link import TCLink

import argparse
from time import sleep
import signal

import unittest

import code
# code.interact(local=dict(globals(), **locals()))

_THIS_DIR = os.path.dirname(os.path.realpath(__file__))
_THRIFT_BASE_PORT = 22222
_HP4_CTRL_PORT = 33333
_MININET_DEBUG = False
_TEST_DEBUG = False

class TestTopo(Topo):
  def __init__(self, **opts):
    self.json = opts.pop('json')
    super(TestTopo, self).__init__(**opts)
    links = [ ('h1', 's1'),
              ('h2', 's1'),
              ('h3', 's1')]
    behavioral = os.environ['BMV2_PATH'].rstrip() + \
                                     '/targets/simple_switch/simple_switch'
    switch = self.addSwitch('s1', sw_path = behavioral,
                            json_path = self.json,
                            thrift_port = _THRIFT_BASE_PORT,
                            pcap_dump = False,
                            device_id = 0)
    for h in xrange(3):
      host = self.addHost('h%d' % (h + 1),
                          ip = '10.0.0.%d/24' % (h+1),
                          mac = '00:04:00:00:00:%02x' %h)

    for a, b in links:
      self.addLink(a, b)

# https://stackoverflow.com/questions/11380413/python-unittest-passing-arguments/20702984
class TestLoaderWithKwargs(unittest.TestLoader):
    """A test loader which allows to parse keyword arguments to the
       test case class."""
    def loadTestsFromTestCase(self, testCaseClass, **kwargs):
        """Return a suite of all tests cases contained in 
           testCaseClass."""
        if issubclass(testCaseClass, unittest.suite.TestSuite):
            raise TypeError("Test cases should not be derived from "\
                            "TestSuite. Maybe you meant to derive from"\
                            " TestCase?")
        testCaseNames = self.getTestCaseNames(testCaseClass)
        if not testCaseNames and hasattr(testCaseClass, 'runTest'):
            testCaseNames = ['runTest']

        # Modification here: parse keyword arguments to testCaseClass.
        test_cases = []
        for test_case_name in testCaseNames:
            test_cases.append(testCaseClass(test_case_name, **kwargs))
        loaded_suite = self.suiteClass(test_cases)

        return loaded_suite 

def testdebug_print(s):
  if _TEST_DEBUG:
    print(s)

class TestPings(unittest.TestCase):

    def __init__(self, *args, **kwargs):
      self.net = kwargs.pop('mn')
      super(TestPings, self).__init__(*args, **kwargs)

    @staticmethod
    def get_loss(ping_res):
      _TRANSMITTED = 0
      _RECEIVED = 1
      _LOSS = 2
      _TIME = 3
      res_lines = ping_res.split('\n')
      for line in res_lines:
        if 'packet loss' in line:
          return line.split(', ')[_LOSS]
      return 'error; packet loss not found'

    def test_good_ping(self):
        h1 = self.net.get('h1')
        res = h1.cmd("ping 10.0.0.2 -c 1 -W 1")
        testdebug_print('good_ping: ' + res)
        ans = self.get_loss(res)
        self.assertEqual(ans, '0% packet loss')

    def test_bad_ping(self):
      h1 = self.net.get('h1')
      res = h1.cmd("ping 10.0.0.3 -c 1 -W 1")
      testdebug_print('bad_ping: ' + res)
      ans = self.get_loss(res)
      self.assertEqual(ans, '100% packet loss')

def mndebug_print(s):
  if _MININET_DEBUG:
    print(s)

def hp4_ctrl_start(devname, slicename):
  controllerpath = os.environ['HP4_CTRL_PATH'].rstrip() + '/hp4controller/controller.py'

  p = subprocess.Popen([controllerpath])
  # TODO: cleaner solution?
  sleep(1) # wait until socket is open
  hp4c = HP4ClientAdmin()

  # create_device <devname> <devip> <devport> <devtype> <dev pre engine>
  #               <devrulelimit> <dev ifaces>
  devip = 'localhost'
  devport = '22222' # port for control plane
  devtype = 'bmv2_SSwitch'
  devpre = 'SimplePreLAG' # pre = packet replication engine
  devrulelimit = '1000'
  devifaces = ['1', '2', '3', '4']
  hp4c.do_create_device(devname + ' ' + \
                        devip + ' ' + \
                        devport + ' ' + \
                        devtype + ' ' + \
                        devpre + ' ' + \
                        devrulelimit + ' ' + \
                        ' '.join(devifaces))
            
  # create_slice <slicename>
  hp4c.do_create_slice(slicename)

  # grant_lease <slicename> <devname> <slicerulelimit> <slicetype> <dev ifaces>
  slicerulelimit = '500'
  slicetype = 'Chain'
  hp4c.do_grant_lease(slicename + ' ' + \
                      devname + ' ' + \
                      slicerulelimit + ' ' + \
                      slicetype + ' ' + \
                      ' '.join(devifaces)) # all the interfaces
  return p

def hp4_vdev_start(project, slicename, devname):
  vdev_p4path = project + '.p4'
  vdev_cmdfile = project + '.commands'
  hp4c = HP4ClientSliceManager(user=slicename)

  # vdev_create <p4 path> <vdevname>
  hp4c.do_vdev_create(vdev_p4path + ' ' + project)

  # lease_insert <devname> <vdevname> <vdev chain position> <vdev egr handling>
  vdev_position = '0'
  vdev_egress_handling = 'etrue'
  hp4c.do_lease_insert(devname + ' ' + project + ' ' + \
                       vdev_position + ' ' + vdev_egress_handling)

  # lease_config_egress <devname> <vegr spec> <vegr cmd> <vegr mcast filtered>
  vegress_spec = '5'
  vegress_command = 'mcast'
  vegress_mcast_filtered = 'filtered'
  hp4c.do_lease_config_egress(devname + ' ' + vegress_spec + ' ' + \
                              vegress_command + ' ' + vegress_mcast_filtered)

  # vdev_interpretf <vdevname> <devtype> <vdev cmdfile path>
  devtype = 'bmv2'
  hp4c.do_vdev_interpretf(project + ' ' + devtype + ' ' + vdev_cmdfile)

def mn_start(project):
  hp4_jsonpath = '../hp4/hp4.json'
  hp4_cmdfile = '../hp4.hp4commands.txt'
  topo = TestTopo(json=hp4_jsonpath)
  net = Mininet(topo = topo,
                host = P4Host,
                switch = P4Switch,
                controller = None)
  net.start()

  for n in xrange(3):
      h = net.get('h%d' % (n + 1))
      for off in ["rx", "tx", "sg"]:
          cmd = "/sbin/ethtool --offload eth0 %s off" % off
          mndebug_print(cmd)
          h.cmd(cmd)
      h.cmd("sysctl -w net.ipv4.tcp_congestion_control=reno")
      h.cmd("iptables -I OUTPUT -p icmp --icmp-type destination-unreachable -j DROP")
      h.setDefaultRoute("dev eth0")

  cli = os.environ['BMV2_PATH'].rstrip() + '/targets/simple_switch/sswitch_CLI'
  cmd = [cli, hp4_jsonpath, str(_THRIFT_BASE_PORT)]
  if os.path.isfile(hp4_cmdfile):
    with open(hp4_cmdfile, "r") as f:
      mndebug_print(" ".join(cmd))
      try:
        output = subprocess.check_output(cmd, stdin = f)
        mndebug_print(output)
      except subprocess.CalledProcessError as e:
        print e
        print e.output
  else:
    mndebug_print(hp4_cmdfile + " not found")

  # invoke controller to set up slice and vdev
  devname = 'alpha'
  slicename = 'jupiter'
  p = hp4_ctrl_start(devname, slicename)
  hp4_vdev_start(project, slicename, devname)

  sleep(1)
  mndebug_print("ready!")

  CLI( net )

  return net, p

def main(project='test_select', tc_class_name='TestSelect'):
  net, p = mn_start(project)
  #loader = TestLoaderWithKwargs()
  #tc_class = reduce(getattr, tc_class_name.split("."), sys.modules[__name__])
  #suite = loader.loadTestsFromTestCase(tc_class, mn=net)
  #unittest.TextTestRunner(verbosity=2).run(suite)
  net.stop()
  p.send_signal(signal.SIGTERM)

if __name__ == '__main__':
  main()
