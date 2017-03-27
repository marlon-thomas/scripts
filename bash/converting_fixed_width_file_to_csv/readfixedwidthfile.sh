#!/bin/bash

main()
{

HEADER=$(head -n 1 fixedinput | expand ) # expand in case of tabs in file
FIELDS=$( echo $HEADER | awk {' for (i=1;i<=NF;i++) print $i '})

idxvalues=()
i=0
for f in ${FIELDS[@]}; do
  idx=$(strindex "$HEADER" "$f")
  idxvalues[$i]=$idx
  ((i++))
done
# add length of longest line in file to idxvalues
idxvalues[$i]=$(( $( wc -L fixedinput | awk '{print $1}' ) + 1 )) 

colwidths=()
j=0
for (( i=0; i<${#idxvalues[@]}; i++ )); do
  if [ $i -gt 0 ]; then
     colwidths[$j]=$(( idxvalues[$i] - idxvalues[$i-1] ))
     ((j++))
  fi
done
   
echo ${colwidths[@]}
expand fixedinput | sed -e '2,1d' | awk -v colw="$( echo ${colwidths[@]})" -f csv.awk > outfile 

}

strindex() { 
  PARENT=$1
  SUBSTRING=$2
  echo $(awk -v a="$PARENT" -v b="$SUBSTRING" 'BEGIN{print index(a,b)}')
}

main

