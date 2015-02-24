#!/bin/bash

debug=1

r='\033[31m'
w='\033[0m'
g='\033[32m'
y='\033[33m'

echo "** This script will run basic checks for preparing a patching maintenance plan"
echo "** It will not make any changes, and you may wish to run further checks in"
echo "** addition"
echo ""

# Prompt to check AMGs
echo ""
echo -e "$y[MANUAL]$w Check AMGs"

# Check if this is an RHCS cluster
if [ -f /etc/cluster/cluster.conf ]; then
  echo -e "$y[WARNING]$w This is an RHCS cluster node, use the patch-rhcs.txt template"
else
  echo -e "$g[ OK ]$w This isn't an RHCS cluster node, use the patch.txt template"
fi

# Note pre maintenance state
date=$(date +"%s-%m-%d-%Y")
#Save a list of ports, processes, mounts, service set to start on boot,
mkdir ~/patching-qc-$date
netstat -plntu >> ~/patching-qc-$date/ports
ps -ef >> ~/patching-qc-$date/process
mount >> ~/patching-qc-$date/mount
chkconfig --list >> ~/patching-qc-$date/services-set-to-start-on-boot

# Kernel upgrade check
kernel1=$(uname -r)
kernel2=$(yum --disableexcludes=all check-update kernel 2> /dev/null | awk '/kernel/ {print $2}')
echo -e "$g[ OK ]$w Current kernel version is $kernel1"

if [ -n "$kernel2"  ]; then
  if [ $(powermt display dev=all 2>/dev/null | grep -c emc) -gt 0 ]; then
    echo -e "$y[WARNING]$w Kernel will be updated to $kernel2. Check certificatation matrix for SAN"
  else
    echo -e "$g[ OK ]$w Kernel will be updated to $kernel2; a restart will be required"
  fi
fi

#Reboot Checks
#1. NFS, mount and fstab check.
fstab=`grep -c :/ /etc/fstab`
mounted=`df -h | grep -c :/`
netfschk=`chkconfig --list | awk '/netfs/ {print $5}' | cut -d : -f2`

if [ "$fstab" -gt 0 ] || [ "$mounted" -gt 0 ]; then
  if [ "$fstab" = "$mounted" ]; then
    [ -n "$debug" ] && echo -e "$g[ OK ]$w All the NFS partitions mounted are listed under fstab are mounted."
  else
    echo -e "$r[FAIL]$w Not all the NFS partitions defined under fstab are mounted or vice versa, please check"
  fi

  if [ "$netfschk" == "on" ]; then
    [ -n "$debug" ] && echo -e "$g[ OK ]$w netfs is switched on"
  else
    echo -e "$g[ OK ]$w netfs is switched off, please chkconfig netfs on"
  fi
  else
    [ -n "$debug" ] && echo -e "$g[ OK ]$w There are no NFS mounts"
fi

echo ""
echo "Checking services:"
# Check for services listening and configured to start at boot
listening=$(netstat -plnt | awk '{print $7}' | sed 1,2d | cut -d "/" -f2 | sed 's/(.*//' | sort | uniq)

for service in $listening; do
  case $service in
    "master")
       service="postfix"
       ;;
    "mrouter")
       service="sav-rms"
       ;;
    "magent")
       service="sav-rms"
       ;;
    "cvd")
       service="Galaxy"
       ;;
    "EvMgrC")
       service="Galaxy"
       ;;
    "rpc.statd")
       service="nfslock"
       ;;
    "zabbix_agentd")
       service="zabbix-agent"
       ;;
  esac
  
  if [ $(chkconfig --list | grep :on | grep -c $service) -gt 0 ]; then
    [ -n "$debug" ] && echo -e "$g[ OK ]$w $service is set to start at boot time"
  else
    echo -e "$r[FAIL]$w $service doesn't seem to be set to start at boot time, investigate"
  fi
done

echo ""

# Check for PowerPath devices
if [ $(powermt display dev=all 2>/dev/null | grep -c emc) -gt 0 ]; then
  echo -e "$y[WARNING]$w This server is SAN attached, ensure SAN steps are included"
else
  [ -n "$debug" ] && echo -e "$g[ OK ]$w No SAN LUNs on this Server"
fi

echo -e "$y[MANUAL]$w Check for any faults logged in /var/log/messages"
