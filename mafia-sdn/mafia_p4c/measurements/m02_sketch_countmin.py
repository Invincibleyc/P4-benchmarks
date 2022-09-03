# Program using MAFIA API as of documentation:
# 
# declare sketch countmin_sketch<32>[4][256]
# declare hash_set countmin_hash_set (H=4, countmin_hash): {ipv4.src, ipv4.dst, ipv4.protocol, tcp.src, tcp.dst} 
#                                                          -> {h<2>, index<8>}
# 
# Sketch( lambda(countmin_hash_set): { countmin_sketch[h][index] = countmin_sketch[h][index] + 1 }, countmin_sketch) 
# 

from mafia_lang.primitives import *

# Declare a register for 4x256 32-bit cells to hold the sketch
countmin_sketch = Sketch('countmin_sketch', 4, 256, 32)

# Declares a family of 4 hash functions of type 'countmin_hash' (second parameter) 
# 'countmin_hash' is a pre-existing hash function.
# (i.e, known *BY THE COMPILER*, which provides a black-box implementation).
# 3rd parameter is an array of header fields used as input to the hash.
# 4th parameter is an array of output variable generated by each of 4 hash functions.
countmin_hash_set = HashFunction( \
                                    'countmin_hash_set', \
                                    'countmin_hash', \
                                    4, \
                                    [ "ipv4.src", "ipv4.dst", "tcp.src", "tcp.dst", "ipv4.protocol"], \
                                    [ HashOutputVar('h', 2), HashOutputVar('index', 8) ] \
                                )

s = Sketch_op('countmin_sketch', 'lambda(countmin_hash_set): { countmin_sketch[h][index] = countmin_sketch[h][index] + 1}', countmin_sketch)

measurement = s