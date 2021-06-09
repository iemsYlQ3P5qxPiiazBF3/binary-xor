#!/bin/bash
encrypted="$(cat $1|xxd -u -p|sed 's/.\{2\}/& /g')"
key="$(cat $2|head -c $(wc -c <$1)|xxd -u -p|sed 's/.\{2\}/& /g')"
key=( $key )
keyloopover="0"
#keyloopover defines the place in the array
for dataloop in $encrypted;do
	dataloop=$(bc<<<"ibase=G;obase=A;$dataloop")
	key_loop=${key[$keyloopover]}
	((keyloopover++))
	key_loop=$(bc<<<"ibase=G;obase=A;$key_loop")
	#both are converted to decimal
	xord=$((dataloop^key_loop))
	xord=$(bc<<<"ibase=A;obase=G;$xord")
	[ "$(echo -n $xord|wc -c)" -lt "2" ]&&xord="0$xord"
	decrypted+="$xord"
done
sed 's/.\{2\}/& /g'<<<"$decrypted"
xxd -p -r<<<"$decrypted">decrypted