cp $1 $(echo $1|sed "s/.m4a//"|awk -F"_-_" '{print $2,"_-_",$1,".m4a"}'|sed "s/ //g")
rm $1
