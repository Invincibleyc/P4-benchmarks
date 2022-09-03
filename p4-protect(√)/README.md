# P4-Protect BMv2 Implementation 

## Structure 

- **src/components**: Contains the P4 Implementation 
- **src/components/controls**: Contains the P4 control blocks 


## Naming 

Note that the described implementation in **P4-Protect: 1+1 Path Protection for P4** is mainly based on the Tofino Implementation and that the BMv2 Implementation has some differences. 
Especially the naming has some differences:

- **Protect&Forward**: The Protect&Forward functionality is implemented by the control block **IP**.   
- **Decaps-IP**: The Decaps-IP functionality is directly implemented by the control block **IP**.
- **Decaps-P**: The Decaps-P functionality is implemented by the control block **Protect**.  
  - **ProtectedFlows**: The MAT ProtectedFlows is implemented by the tables protected\_services. Upon pkt arrival, a copy is sent to the controller. The controller then decides whether this specific flow should be protected. The actual protection is done by the l3\_match\_to\_index table.
