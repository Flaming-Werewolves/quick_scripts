grep current: /proc/vmmemctl | awk '{sum=$2*4096/1048576} {print sum  MB}'
