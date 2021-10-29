# A few simple shell functions to convert IP addresses
# from hex or binary to decimal (IPv4) / hex (IPv6)
# notation.
#
# This file is in the public domain.
#
# Made by @jschauma - hit me up if you want to golf it
# down, but simple shell commands only, ok?
#
# Examples:
# IPv4
#
# $ binaryToIPv4 01001010000001101000111100011001
# 74.6.143.25
# $ ipv4ToHex 74.6.143.25
# 4A 06 8F 19
# $ hexToIPv4 4A 06 8F 19
# 74.6.143.25
# $ ipv4ToBinary 74.6.143.25
# 01001010000001101000111100011001
# $ binaryIPv4ToHex 01001010000001101000111100011001
# 4A 06 8F 19
#
# IPv6
#
# $ ipv6ToBinary 2001:4998:124:1507::f000
# 00100000000000010100100110011000000000010010010000010101000001110000000000000000000000000000000000000000000000001111000000000000
# $ binaryToIPv6 00100000000000010100100110011000000000010010010000010101000001110000000000000000000000000000000000000000000000001111000000000000
# 2001:4998:124:1507::F000

binaryToDec() {
	b="$@";
	if [ -z "$b" ]; then
		read b;
	fi;
	echo "ibase=2; $b" | bc
}

binaryToOct() {
	b="$@";
	if [ -z "$b" ]; then
		read b;
	fi;
	echo "ibase=2; obase=8; $b" | bc | sed -e 's/^/0/'
}

binaryToIPv4() {
	ip="$@";
	if [ -z "$ip" ]; then
		read ip;
	fi;
	echo "$ip" | 						\
		sed 's/\(.\{8\}\)/\1 /g' | tr ' ' '\n' |	\
		( echo ibase=2; xargs -n 1 ) | bc |		\
		tr '\n' '.' | sed -e 's/\.$//';
}

binaryIPv4ToHex() {
	ip="$@";
	if [ -z "$ip" ]; then
		read ip;
	fi;
	echo "$ip" | binaryToIPv4 | ipv4ToHex
}

decToBinary() {
	d="$@";
	if [ -z "$d" ]; then
		read d;
	fi;
	echo "obase=2; $d" | bc
}

decToIPv4() {
	d="$@";
	if [ -z "$d" ]; then
		read d;
	fi;
	decToBinary "${d}" | binaryToIPv4
}

decToIPv6() {
	d="$@";
	if [ -z "$d" ]; then
		read d;
	fi;
	export BC_LINE_LENGTH=128
	binaryToIPv6 $(printf "%0128s" $(decToBinary "${d}"))
}


hexToIPv4() {
	ip="$@";
	if [ -z "$ip" ];
		then read ip;
	fi;
	echo "$ip" | 						\
		tr -d '[:space:]' |				\
		tr '[a-z]' '[A-Z]' |				\
		sed 's/\(.\{2\}\)/\1 /g' | tr ' ' '\n' |	\
		( echo ibase=16; xargs -n 1 ) | bc |	 	\
		tr '\n' '.' | sed -e 's/\.$//' | xargs;
}

ipv4ToBinary() {
	ip="$@";
	if [ -z "$ip" ];
		then read ip;
	fi;
	echo "$ip" | tr . '\n' | 				\
		( echo obase=2; xargs -n 1; ) | bc |		\
		sed -e :a -e 's/^.\{1,7\}$/0&/;ta' |		\
		tr -d '\n' | xargs;
}

ipv4ToDec() {
	ip="$@";
	if [ -z "$ip" ];
		then read ip;
	fi;
	ipv4ToBinary "${ip}" | binaryToDec
}

ipv4ToHex() {
	ip="$@";
	if [ -z "$ip" ];
		then read ip;
	fi;
	echo "$ip" | tr . '\n' |				\
		( echo obase=16; xargs -n 1; ) | bc |		\
		sed -e :a -e 's/^.\{1,1\}$/0&/;ta' |		\
		tr '\n' ' ' | xargs;
}

ipv4ToOct() {
	ip="$@";
	if [ -z "$ip" ];
		then read ip;
	fi;
	ipv4ToBinary "${ip}" | binaryToOct
}

ipv6ToDec() {
	ip="$@";
	if [ -z "$ip" ];
		then read ip;
	fi;
	export BC_LINE_LENGTH=128
	ipv6ToBinary "${ip}" | binaryToDec
}

ipv6ToBinary() {
	ip="$@";
	if [ -z "$ip" ];
		then read ip;
	fi;
	echo "$ip" | 							\
		sed -e "s/::/:$(jot -b 0000 $(( 8 - $(echo "${ip}" | tr ':' '\n' | grep . | wc -l) )) 0 0 2>/dev/null | \
		tr '\n' ':')/" | tr ':' '\n' | 				\
		sed -e :a -e 's/^.\{1,4\}$/0&/;ta' | 			\
		tr '[a-z]' '[A-Z]' |  					\
		( echo "ibase=16; obase=2;"; xargs -n 1; ) | 		\
		bc | sed -e :a -e 's/^.\{1,15\}$/0&/;ta' | 		\
		tr -d '\n' | xargs
}

ipv6ToDec() {
	ip="$@";
	if [ -z "$ip" ];
		then read ip;
	fi;
	export BC_LINE_LENGTH=128
	ipv6ToBinary "${ip}" | binaryToDec
}

binaryToIPv6() {
	ip="$@";
	if [ -z "$ip" ]; then
		read ip;
	fi;
	echo "$ip" | 							\
		sed 's/\(.\{16\}\)/\1 /g' | tr ' ' '\n' | 		\
		( echo 'obase=16; ibase=2;';  xargs -n 1 ) | bc |	\
		tr '\n' ':' |						\
		sed -e 's/:[0:]*:/::/' -e 's/^0*//' -e 's/:$//'
}
