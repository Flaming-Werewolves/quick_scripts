lsof|awk '/deleted/ {print $7 " " $9'}|sort|uniq|awk '{sum+=$1} END {printf "%.0fMB\n",(sum/1048576)}'
