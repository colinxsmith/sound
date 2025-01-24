#!/bin/bash
echo newmeth.sh \<start time eg. 2200 for 10pm\> \<day of week: 0 is Sunday 1 is Saturday \(one day before\)\>
day=$(date +%w)
today=$(date +%s)
off=$(($(($((day + ${2:-0}))))*24*60*60))
before=$(($today-$off))
base=la.hellorayo.co.uk
start=${1:-2200}
secsoff=-3600

echo start at time $start on $(date --date=@$(($before)) +%Y%m%d)

file=https://$base/jazz/Jazz-$(date --date=@$(($before)) +%Y%m%d)-$start.mp3
echo $file

cd ~/sound

if [ $start = '2200' ]
then 
    if [ ${2:-0} = '0' ]
    then
echo 10pm on Sunday
curl -L $file > jn.mp3
rm ~/Music/j3hour.mp3
cp jn.mp3 ~/Music/j3hour.mp3
    elif [ ${2:-0} = '1' ]
    then
echo 10pm on Saturday
curl -L $file > ny.mp3
rm ~/Music/j3hour.mp3
cp ny.mp3 ~/Music/j3hour.mp3
    fi
elif [ $start = '1800' ]
then
    if [ ${2:-0} = '0' ]
    then
echo 6pm on Sunday
    elif [ ${2:-0} = '1' ]
    then
echo 6pm on Saturday
curl -L $file > cp.mp3
rm ~/Music/j3hour.mp3
cp cp.mp3 ~/Music/j3hour.mp3
    fi
elif [ $start = '1700' ]
then
    if [ ${2:-0} = '0' ]
    then
echo 5pm on Sunday
curl -L $file > df.mp3
rm ~/Music/j3hour.mp3
cp df.mp3 ~/Music/j3hour.mp3
    elif [ ${2:-0} = '1' ]
    then
echo 5pm on Saturday
    fi
fi