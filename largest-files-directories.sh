date; echo -e "Largest Folders:\n"; nice -n 19 du -xSk `pwd` | sort -rn | head -30|awk '{printf "%d MB\t%s\n",($1/1024),$NF}' && echo -e "\n\n";date; echo -e "Largest Files:\n"; nice -n 19 find `pwd` -mount -type f -ls|sort -rnk7 |head -30|awk '{printf "%d MB\t%s\n",($7/1024)/1024,$NF}'

