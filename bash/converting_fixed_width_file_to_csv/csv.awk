@include "awk.functions"

BEGIN { 
  FIELDWIDTHS=colw
  OFS=","
}
{
  for (i = 1; i <= NF; i++) {
   $i=trim($i)
  }
  print
}
END {
}
