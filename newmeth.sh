#!/bin/bash
echo $0 \<time e.g. 2200 for start of recording\> \<day of week Monday is 1\>
day=$(date +%w)
today=$(date +%s)
off=$(echo $day-${2:-7}|awk -F "-" '{ print (($1-$2>=0?$1-$2:7+$1-$2))*24*3600; }')
echo $off
before=$(($today-$off))
echo $before
base=la.hellorayo.co.uk
start=${1:-2200}

echo start at time $start on $(date --date=@$(($before)) +%Y%m%d)

file=https://$base/jazz/Jazz-$(date --date=@$(($before)) +%Y%m%d)-$start.mp3
echo $file

codeback=$(curl -LIs $file -o /dev/null -w "%{http_code}\n")
echo $codeback
if [ $codeback != '200' ]
then
	echo -e "Sound file:\e[31m $file is not available\e[0m "
	while [ $codeback == '408' ] || [ $codeback == '521' ] || [ $codeback == '504' ]
	do
                sleep 180
		codeback=$(curl -LIs $file -o /dev/null -w "%{http_code}\n")
		echo -e "Again sound file:\e[31m $file is not available\e[0m "
		echo $codeback
	done
        if [ $codeback != '200' ]
        then
	        exit 12
        fi
fi

cd ~/sound

if [ $start = '2200' ]
then 
    if [ ${2:-0} = '7' ]
    then
echo 10pm on Sunday
curl -L $file > temp.mp3
id3v2 -l temp.mp3
if [ $(ls -l temp.mp3 | awk '{ print $5 }') -gt 1000 ]; then id3v2 -c "$(date +%a-%d-%m-%Y:%T) $(uname -a)" temp.mp3; mv temp.mp3 jn.mp3;fi

rm ~/Music/j3hour.mp3
cp jn.mp3 ~/Music
cp jn.mp3 ~/Music/mp3
cp jn.mp3 ~/Music/j3hour.mp3
cat df.mp3 >> ~/Music/j3hour.mp3
    elif [ ${2:-0} = '6' ]
    then
echo 10pm on Saturday
curl -L $file > temp.mp3
id3v2 -l temp.mp3
if [ $(ls -l temp.mp3 | awk '{ print $5 }') -gt 1000 ]; then id3v2 -c "$(date +%a-%d-%m-%Y:%T) $(uname -a)" temp.mp3; mv temp.mp3 ny.mp3;fi

rm ~/Music/j3hour.mp3
cp ny.mp3 ~/Music
cp ny.mp3 ~/Music/mp3
cp ny.mp3 ~/Music/j3hour.mp3
cat cp.mp3 >> ~/Music/j3hour.mp3
    fi
elif [ $start = '1800' ]
then
    if [ ${2:-0} = '7' ]
    then
echo 6pm on Sunday
    elif [ ${2:-0} = '6' ]
    then
echo 6pm on Saturday
curl -L $file > temp.mp3
id3v2 -l temp.mp3
if [ $(ls -l temp.mp3 | awk '{ print $5 }') -gt 1000 ]; then id3v2 -c "$(date +%a-%d-%m-%Y:%T) $(uname -a)" temp.mp3; mv temp.mp3 cp.mp3;fi

rm ~/Music/j3hour.mp3
cp cp.mp3 ~/Music
cp cp.mp3 ~/Music/mp3
cp cp.mp3 ~/Music/j3hour.mp3
    fi
elif [ $start = '2100' ]
then
    if [ ${2:-0} = '5' ]
    then
echo 9pm on Friday
echo $(ls -l af.mp3 | awk '{ print $5 }')
curl -L $file > temp.mp3
id3v2 -l temp.mp3
if [ $(ls -l temp.mp3 | awk '{ print $5 }') -gt 1000 ]; then id3v2 -c "$(date +%a-%d-%m-%Y:%T) $(uname -a)" temp.mp3; mv temp.mp3 af.mp3;fi

rm ~/Music/j3hour.mp3
cp af.mp3 ~/Music
cp af.mp3 ~/Music/mp3
cp af.mp3 ~/Music/j3hour.mp3
    fi
elif [ $start = '1700' ]
then
    if [ ${2:-0} = '7' ]
    then
echo 5pm on Sunday
curl -L $file > temp.mp3
id3v2 -l temp.mp3
if [ $(ls -l temp.mp3 | awk '{ print $5 }') -gt 1000 ]; then id3v2 -c "$(date +%a-%d-%m-%Y:%T) $(uname -a)" temp.mp3; mv temp.mp3 df.mp3;fi

rm ~/Music/j3hour.mp3
cp df.mp3 ~/Music
cp df.mp3 ~/Music/mp3
cp df.mp3 ~/Music/j3hour.mp3
    elif [ ${2:-0} = '6' ]
    then
echo 5pm on Saturday
    fi
else
curl -L $file > temp.mp3
id3v2 -l temp.mp3
if [ $(ls -l temp.mp3 | awk '{ print $5 }') -gt 1000 ]; then id3v2 -c "$(date +%a-%d-%m-%Y:%T) $(uname -a)" temp.mp3; mv temp.mp3 jazz.mp3;fi

fi
mpc --wait update 
