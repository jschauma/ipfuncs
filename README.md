This repository contains a few shell functions that
are useful to convert different IP addresses and
formats.

The examples should all be self-explanatory:

```
$ ipv4ToBinary 198.51.100.215
11000110001100110110010011010111
$ ipv4ToBinary 198.51.100.215 | binaryToIPv4
198.51.100.215
$ ipv4ToHex 198.51.100.215
C6 33 64 D7
$ ipv4ToHex 198.51.100.215 | hexToIPv4
198.51.100.215
$ ipv4ToBinary 198.51.100.215 | binaryIPv4ToHex 
C6 33 64 D7
$ ipv6ToBinary 2001:db8::f005:ba11                          
00100000000000010000110110111000000000000000000000000000000000000000000000000000000000000000000011110000000001011011101000010001
$ ipv6ToBinary 2001:db8::f005:ba11 | binaryToIPv6
2001:DB8::F005:BA11
$ ipv4ToDec 166.84.7.99
2790524771
$ decToBinary 2790524771
10100110010101000000011101100011
$ decToBinary 2790524771 | binaryToIPv4
166.84.7.99
$ 
```
