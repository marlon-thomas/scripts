#!/bin/bash
#export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
clear
rm -f ./run.log > /dev/null
horline="=================================================================================================="
main()
{
  ALL_HOSTS=("host1" "host2" "host3" "host4" "host5" "host6" "host7" "host8" "host9" "host10" "host11")
  DM_HOSTS=("host1" "host2" "host3" "host4")

  echo "Deploying to the following hosts:"
  echo "${ALL_HOSTS[@]}"
  echo
  printf "Press 'C' when ready to proceed, CTRL+C to exit: "
  INPUT=""
  while [[ ! "$INPUT" =~ ^[Cc]$ ]]; do read -n 1 -s INPUT ; done
  echo

  for host_name in "${ALL_HOSTS[@]}"; do

    is_DM_HOST=false

    containsElement "$host_name" "${DM_HOSTS[@]}"
    return_val="$?"

    if [ "$return_val" == "0" ]; then is_DM_HOST=true ; fi

    ssh ${host_name} "/bin/bash -s" < "./task_script.sh" "$is_DM_HOST" | tee -a ./run.log

    echo
    printf "ATTENTION: Deployment to $host_name completed. Press 'C' when ready to proceed: "
    INPUT=""
    while [[ ! "$INPUT" =~ ^[Cc]$ ]]; do read -n 1 -s INPUT ; done
    echo
  done
  echo $horline
  echo " Deployment for all hosts completed."
  echo " Please complete any remaining manual tasks"
  echo $horline
}

containsElement ()
{
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

main "$@"
