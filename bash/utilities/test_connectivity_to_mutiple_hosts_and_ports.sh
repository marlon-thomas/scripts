##!/bin/bash

main()
{
 clear
 targets_to_test=("server1:1622:1621" "server2:1622")

 hline="====================================================================================="
 my_ip_address=$(ifconfig | grep -C 1 eth0 | tail -n 1 | awk '{print $2}' | sed 's/[A-Za-z:]//g')
 echo $hline
 echo "Testing connectivity from $HOSTNAME ( $my_ip_address ) ..."
 echo $hline
 for target in "${targets_to_test[@]}" ; do

   svr=$( echo $target | awk -F":" '{print $1'})
   target_full_hostname=$(get_full_hostname "$svr")
   target_ip_address=$(get_ip_address "$svr")
   target_ports=$(echo $( echo $target | awk -F":" '{ for (i=2;i<=NF;i++) print $i }' ))
   printf "To: $target_full_hostname ( $target_ip_address )\nTarget Port(s): $target_ports\n"
   for port in ${target_ports[@]}; do
       nc -zv $target_ip_address $port
   done
   echo -------------------------------------------------------------------------------------
 done
}

get_ip_address()
{
  echo $(nslookup $1 | grep -A 2 "answer" | grep -i address | awk '{print $2}')
}

get_full_hostname()
{
 echo $(nslookup $1 | grep -A 2 "answer" | grep -i name | awk '{print $2}')
}
main
