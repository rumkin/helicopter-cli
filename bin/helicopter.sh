#!/bin/bash

set -e

CURRENT=($(echo $PWD | tr "/" "\n"))
TAIL=node_modules/helicopter/bin/helicopter.js

for (( i=${#CURRENT[@]}; i >= 0; i-- ))
do
  DIR=""
  for (( n=0; n<=$i; n++ ))
  do
      DIR=$DIR"/${CURRENT[$n]}"
  done

  if [ -f "$DIR/$TAIL" ]
  then
    ${DIR}/${TAIL} $@ <&0
    exit
  fi
done

echo "Helicopter executable not found" > &2
exit 1
