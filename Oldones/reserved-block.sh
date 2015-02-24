dumpe2fs -h /dev/mapper/$drive | egrep 'Block count:|Reserved block count:'| awk -F":" '{print $2}' | xargs echo | awk '{ print "Reserve blocks currently set to " ($2 / $1)*100"%"}';
