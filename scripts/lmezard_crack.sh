#!/bin/bash

# Clean
rm -rf $HOME/ft_fun
rm -rf $HOME/main.c

# Exttract archive
tar -xvf fun
cd ft_fun

# Get file number and extract the code part into a new file
mkdir -pv $HOME/files
for f in $(ls *.pcap)
do
  ARCHIVE_NUMBER="$(cat $f | grep file | sed 's/^.*file//g')"
  cat $f | sed 's/\/\/file[0-9]*//g' > $HOME/files/"$ARCHIVE_NUMBER"
done

# Gather files in order to rebuild the original file
cd $HOME/files
for i in $(ls -1 | sort -n)
do
  cat $i >> $HOME/main.c
done

# Compile the program
cd $HOME
gcc main.c -o solution && ./solution | grep PASSWORD | rev | cut -d ' ' -f1 | rev > pass
echo pass file:
cat pass
echo Laurie password is:
password="$(cat pass | tr "\n" '@' | sed 's/@//g' | sha256sum | cut -d ' ' -f1)"
echo $password
