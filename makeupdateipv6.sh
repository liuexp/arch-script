HOSTS=/etc/hosts
UpdatedHOSTS=/etc/hosts.updateipv6.1
#sed -n -e 's/^[0-9]\+:[^\ ]\+\ \([^\ ]*\)\ \?.*/\1/gp' $HOSTS
#echo "set type=AAAA
#server 2001:470:20::2
#gmail.google.com
#"|nslookup|sed -n -e "s/[^ ]\+has AAAA address \(.*\)/\1\tgmail.google.com/gp"
#for entry in `cat $RAWHOSTS`;

for entry in `sed -n -e 's/^[0-9]\+:[^\ \t]\+\ \?\t\?\([^\ \t]*\)\ \?.*/\1/gp' $HOSTS|grep "youtube"`
#do nslookup -type=AAAA $entry>> /dev/null ;
#nslookup -type=AAAA $entry;
do echo "set type=AAAA
	server 2001:470:20::2
	$entry
	"|nslookup |sed -n -e "s/[^ ]\+has AAAA address \(.*\)/\1\t$entry /gp" >> $UpdatedHOSTS
done;

#sed -i "s/^\(.*\)/`nslookup -type=AAA \1/g" $HOSTS
