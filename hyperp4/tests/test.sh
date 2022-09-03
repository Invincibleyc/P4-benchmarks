#!/bin/bash

nodes=( 706 353 270 330 271 272 342 341 268 274 340 )

s1_ip="$(ssh -p 22 dhancock@pc${nodes[1]}.emulab.net "ifconfig eth0 | grep 'inet ' | tr ':' ' '" | awk '{print $3}' )"
s2_ip="$(ssh -p 22 dhancock@pc${nodes[2]}.emulab.net "ifconfig eth0 | grep 'inet ' | tr ':' ' '" | awk '{print $3}' )"
s3_ip="$(ssh -p 22 dhancock@pc${nodes[3]}.emulab.net "ifconfig eth0 | grep 'inet ' | tr ':' ' '" | awk '{print $3}' )"
s4_ip="$(ssh -p 22 dhancock@pc${nodes[4]}.emulab.net "ifconfig eth0 | grep 'inet ' | tr ':' ' '" | awk '{print $3}' )"

printf "#!/bin/bash\n" > infr_manifest.sh
printf "s1_ip=${s1_ip}\n" >> infr_manifest.sh
printf "s2_ip=${s2_ip}\n" >> infr_manifest.sh
printf "s3_ip=${s3_ip}\n" >> infr_manifest.sh
printf "s4_ip=${s4_ip}\n" >> infr_manifest.sh
