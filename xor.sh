#!/bin/bash
opts=$(getopt -o hk:f: --long help,keyfile:,infile:: -- "$@")
eval set -- "$opts"

while :;do
	case "$1" in
		"-h"|"--help")
		echo -en "-k, --keyfile:\n choose between /dev/random and /dev/urandom (0/random, 1/urandom)\n\n-f, --infile:\n file to encrypt";shift;exit
		;;
		"-k"|"--keyfile")
		case "$2" in
			"0"|"random")
			keyfile="/dev/random"
			;;
			"1"|"urandom")
			keyfile="/dev/urandom"
			;;
			*)
			echo "arg for -k ($2) incorrect, use 0, 1 , random, or urandom"
			shift 2
			exit 1
			;;
		esac
		shift 2
		;;
		"-f"|"--infile")
		[ -e "$2" ]&&file=$2||{ echo "$2 does not exist";exit 1;}
		shift 2
		;;
		"--")
		shift;break
		;;
		*)
		echo "incorrect option: $1"
		exit 1
		;;
	esac
done

[ ! -e "$keyfile" ]&&exit

data="$(cat $file|xxd -u -p|sed 's/.\{2\}/& /g'|tr -d '\n')"
for dataloop in $data;do
        dataloop=$(bc <<<"ibase=G;obase=A;$dataloop")
        #converted to base 10 [0-255]
        key=$(hexdump -v -e '/1 "%u"' -n 1 "$keyfile")
        ((key%=256))
        #key=random [0-255]
        xord=$((key^dataloop))
        #xor'd
        xord=$(bc <<<"ibase=A;obase=G;$xord")
        [ "$(echo -n $xord|wc -c)" -lt "2" ]&&xord="0$xord"
        total_encrypted+="$xord"
        key=$(bc <<<"ibase=A;obase=G;$key")
        [ "$(echo -n $key|wc -c)" -lt "2" ]&&key="0$key"
        total_key+="$key"
done
sed 's/.\{2\}/& /g'<<<"$total_encrypted"
echo
sed 's/.\{2\}/& /g'<<<"$total_key"

xxd -p -r<<<"$total_encrypted">encrypted
xxd -p -r<<<"$total_key">key
