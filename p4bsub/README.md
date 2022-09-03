# p4bsub
Code authors: Christoph Gärtner, Ralf Kundel


This work will be published at IEEE/IFIP Network Operations and Management Symposium (NOMS) 2020.
The paper can be found here: "Flexible Content-based Publish/Subscribe over Programmable Data Planes" [Paper](https://www.kom.tu-darmstadt.de/research-results/publications/publications-details/?no_cache=1&pub_id=KGBK20)


## compilation
This repository contains two P4-code bases. For compilation please use the scripts:
``` 
./compile-id_based.sh
```
```
./compile-bitmask.sh
```

## testing
For testing we recommend the use of a VM with the p4_16 compiler and bmv2. For example this one:
```
ftp://ftp.kom.tu-darmstadt.de/VMs/p4_16-codel.ova
```
*Username:* **sdn**
*Password:* **vm**
