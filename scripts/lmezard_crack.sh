#!/bin/bash

rm -rf ../main.c
mkdir -pv ./files
for f in $(ls *.pcap)
do
  ARCHIVE_NUMBER="$(cat $f | grep file | sed 's/^.*file//g')"
  cat $f | sed 's/\/\/file[0-9]*//g' > ./files/"$ARCHIVE_NUMBER"
done

cd files

for i in $(ls -1 | sort -n)
do
  cat $i >> ../../main.c
done

cd ../..

gcc main.c -o solution && ./solution | grep PASSWORD | rev | cut -d ' ' -f1 | rev > pass
echo pass file:
cat pass
echo Laurie password is:
cat pass | tr "\n" '@' | sed 's/@//g' | sha256sum | cut -d ' ' -f1
