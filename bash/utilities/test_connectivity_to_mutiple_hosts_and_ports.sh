#!/bin/bash

main()
{
 clear
 servers_to_test=("hostname1" "hostname2")
 uklpdpeci120a_ports=("1621")
 uklpdpeci121a_ports=("1622")
 hline="====================================================================================="
 my_ip_address=$(ifconfig | grep -C 1 eth0 | tail -n 1 | awk '{print $2}' | sed 's/[A-Za-z:]//g')
 echo $hline
 echo "Testing connectivity from $HOSTNAME ( $my_ip_address ) ..."
 echo $hline
 i=0
 for s in "${servers_to_test[@]}" ; do
   target_full_hostname=$(get_full_hostname "$s")
   target_ip_address=$(get_ip_address "$s")
   port_list=${s}_ports
   for target_port in "${!port_list}"; do
      printf "Target host/IP: $target_full_hostname ( $target_ip_address )\nTarget Port: $target_port \n"
      nc -zv $target_ip_address $target_port
   done
   echo -------------------------------------------------------------------------------------
   ((i++))
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
