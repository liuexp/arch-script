ipv4:
	sudo cp /etc/hosts.ipv4 /etc/hosts

noipv4:
	sudo cp /etc/hosts.noipv4 /etc/hosts


ipv6:
	sudo cp /etc/hosts.ipv6 /etc/hosts

noipv6:
	sudo cp /etc/hosts.noipv6 /etc/hosts

newipv6:
	~/makeupdateipv6.sh

ibus:
	killall ibus-daemon 
	ibus-daemon -d

pkgcleancache:
	@~/makepkgcleancache.sh

gset:
	killall gnome-settings-daemon
	/usr/lib/gnome-settings-daemon/gnome-settings-daemon &

watchdisk:
	sudo watch -d -n 1200 'smartctl -a /dev/sda |grep "Current_Pending_Sector"'

watchkernel:
	watch 'dmesg |tail -n 35'

watchdisk2:
	sudo watch -n 360 'echo `smartctl -a /dev/sda |grep -i temp` `smartctl -a /dev/sda |grep -i load`'

kindle:
	sudo ifconfig usb0 192.168.15.1;
	ssh -X root@192.168.15.244

presentation:
	./makepresent.sh

swap:
	mkswap /dev/sda7
	sudo swapon /dev/sda7
proxy:
	/home/liuexp/Downloads/localproxy-2.0.0/proxy.py

