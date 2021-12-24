FILE=$1
GITPATH=$2
echo $GITPATH
str1="rsync -avh --prune-empty-dirs --include '*/' "   
str2=""
while read line || [ -n "$line" ];
do
     path="$line"
     name=$(basename "$path")
     deleteStr=""
     len=${#deleteStr}
     name=${path:len}
     str2="$str2 --include='$name' "
echo $name
done < $FILE
str3="$str1 $str2 --exclude='*' $GITPATH /Users/derekhuang/Desktop/GitChangesOutput/result"

echo "$str3" | bash