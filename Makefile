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

checkoutphysics:
	~/makecheckoutphysics.sh

ibus:
	killall ibus-daemon
	ibus-daemon -d

pkgcleancache:
	~/makepkgcleancache.sh

