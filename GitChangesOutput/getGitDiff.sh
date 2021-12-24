#!/bin/bash
REPOPATH=$1
SHA1=$2
SHA2=$3

rm ~/Desktop/GitChangesOutput/gitDiff.txt
git diff --name-status $SHA2 $SHA1 >> ~/Desktop/GitChangesOutput/gitDiff.txt

rm ~/Desktop/GitChangesOutput/filePath.txt
git diff --name-only $SHA2 $SHA1 >> ~/Desktop/GitChangesOutput/filePath.txt

cd ~/Desktop/GitChangesOutput
rm -rf result

rm programlist.xlsx
/usr/local/bin/python3 writeToXsl.py
./getSourceCode.sh filePath.txt $REPOPATH