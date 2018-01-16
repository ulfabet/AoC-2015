#!/bin/sh

key=abcdef
i=609040

key=iwrupvqb
i=1
i=63000

while [ 1 ]; do
  hash=$(echo -n $key$i | md5sum | cut -c1-5)
  echo $i: $hash
  if [ $hash = "00000" ]; then exit 0; fi 
  let i+=1
done
