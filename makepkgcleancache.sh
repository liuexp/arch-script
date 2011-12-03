################################
## This script lists all packages except the most recent two version.
################################

#rev |sed -n 's/^[^0-9\-]*[0-9i\-\.]*-\(.\+\)/\1 &/p'|rev #|sort -r|uniq -f 1|sort|sed -n 's/^\([^ ]\+\).*/\1/p'
#cat list1| sed -n 's/^\([^0-9]\+\).*/& \1/p'|sort -r|uniq -f 1|sort|sed -n 's/^\([^ ]\+\).*/\1/p' >tmplist1
#cat list2 >tmplist2

################################
## Using xzcat is accurate but extremely slow in general.
################################

#xzcat `ls /var/cache/pacman/pkg/`  |grep -a "pkgname"|sed -n 's/pkgname = \(.*\)/\1/p'   

ls /var/cache/pacman/pkg/ | sed -n 's/^\([^0-9]\+\).*/& \1/p'|sort -r|uniq -f 1|sort|sed -n 's/^\([^ ]\+\).*/\1/p' >tmplist1
ls /var/cache/pacman/pkg/ >tmplist2

sort -n tmplist1 tmplist2|uniq -u | sed -n 's/^\([^0-9]\+\).*/& \1/p'|sort -r|uniq -f 1|sort|sed -n 's/^\([^ ]\+\).*/\1/p'>tmplist3
cat tmplist1 >> tmplist3
sort -n tmplist3 tmplist2|uniq -u 

rm tmplist1
rm tmplist2
rm tmplist3
