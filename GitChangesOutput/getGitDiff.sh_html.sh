#!/bin/bash
REPOPATH=$1
SHA1=$2
SHA2=$3
echo $SHA1
echo $SHA2

fileOutPutPath='/Users/derekhuang/Desktop/GitChangesOutput'
html='getHtml'
sourceCode='getSourceCode'
xsl='getXsl'

# 產生Excel
rm $fileOutPutPath/$xsl/gitDiff.txt
git diff --name-status $SHA2 $SHA1 >> $fileOutPutPath/$xsl/gitDiff.txt

# 產生SourceCode檔案with結構
rm $fileOutPutPath/$sourceCode/filePath.txt
git diff --name-only $SHA2 $SHA1 >> $fileOutPutPath/$sourceCode/filePath.txt

# 產生html差異
rm $fileOutPutPath/$html/patch.diff
git diff $SHA2 $SHA1 >> $fileOutPutPath/$html/patch.diff

# diff2html
rm $fileOutPutPath/Diff.html
export PATH=/usr/local/bin/:~/.nvm/versions/node/v14.2.0/bin:"$PATH"
diff2html -i file -o stdout -- $fileOutPutPath/$html/patch.diff >> $fileOutPutPath/Diff.html

cd $fileOutPutPath
rm -rf result

rm programlist.xlsx
/usr/local/bin/python3 $fileOutPutPath/$xsl/writeToXsl.py
$fileOutPutPath/$sourceCode/getSourceCode.sh $fileOutPutPath/$sourceCode/filePath.txt $REPOPATH
