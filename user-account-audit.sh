
for i in `cat /etc/passwd | cut -d ":" -f 1` ; do uid=`id -u $i` ; if [ "$uid" -lt 500 ] ; then type="system" ; else type="user" ; fi ; if [ $type = "system" ] ; then continue ; fi ; tag=`passwd -S $i | cut -d " " -f 2` ; if [ $tag = PS ] ; then status="Active" ; else status="Inactive/Locked" ; fi ; echo "$type $uid $i $status" ; done | sort -k 3 | column -t
