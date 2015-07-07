#!/bin/bash

newest=$(ls -dtr /Users/mzaleski/Downloads/* | tail -1)

ls -l "$newest"

read -p "hit enter to cp $newest to ." junk

/bin/cp -i "$newest" .

indot=$(basename "$newest")
ls -l "$indot"

