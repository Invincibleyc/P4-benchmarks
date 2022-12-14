#!/bin/bash 
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, 
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
# OTHER DEALINGS IN THE SOFTWARE.
#
# Author: Nicolas Kagami
# Name: Capest

for INTERFACE in s1-eth1 s1-eth2 s2-eth1 s2-eth2 s2-eth3 s3-eth1 s3-eth2 s3-eth3;
do
    tc qdisc del dev $INTERFACE root
    ifconfig $INTERFACE mtu 2000 up
    tc qdisc add dev $INTERFACE root tbf rate 16Mbit latency 10ms burst 2000
done
#Non Homogeneous
for INTERFACE in s3-eth2 s2-eth3;
do
    tc qdisc del dev $INTERFACE root
    ifconfig $INTERFACE mtu 2000 up
    tc qdisc add dev $INTERFACE root tbf rate 8Mbit latency 10ms burst 2000
done
