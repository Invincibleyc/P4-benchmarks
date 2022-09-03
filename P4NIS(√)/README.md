# P4NIS
This is the branch for the P4NIS wireless network. Currently, it includes some source codes and experimental results.

# Papers
* G. Liu, W. Quan, N. Cheng, N. Lu, H. Zhang and X. Shen, "P4NIS: Improving network immunity against eavesdropping with programmable data planes," IEEE INFOCOM 2020 - IEEE Conference on Computer Communications Workshops (INFOCOM WKSHPS), Toronto, ON, Canada, 2020, pp. 91-96, doi: 10.1109/INFOCOMWKSHPS50562.2020.9162975.
* G. Liu, W. Quan, N. Cheng, D. Gao, N. Lu, H. Zhang and X. Shen,  "Softwarized IoT Network Immunity Against Eavesdropping With Programmable Data Planes," in IEEE Internet of Things Journal, vol. 8, no. 8, pp. 6578-6590, 15 April15, 2021, doi: 10.1109/JIOT.2020.3048842.


# Architecture
![image](https://github.com/KB00100100/P4NIS/blob/master/P4NIS_architecture.png)

# run P4NIS 
## client
```
p4c --target bmv2 --arch V1model p4nis_s2.p4 //make 
simple_switch --log-console -i 0@enp2s0 -i 1@veth0 -i 2@veth2 -i 3@veth4 p4nis_s1.json  // run a bmv2 switch
// open a new terminal
./runtime_CLI.py < s2-runtime.txt //install the runtime table
```
## server
```
p4c --target bmv2 --arch V1model p4nis_s2.p4 // make
simple_switch --log-console -i 0@veth0 -i 1@enp8s0f2 -i 2@enp8s0f1 -i 3@enp8s0f0 p4nis_s2.json // run a bmv2 switch
// open a new terminal
./runtime_CLI.py < s2-runtime.txt //install the runtime table
```

