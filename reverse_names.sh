 ls Jeff_Beck*.mp3 | tr ' ' '\n'|tac|tr '\n' ' ' > aa
 cat aa
 for i in $(cat aa); do mpc insert $i; done
 mpc playlist |cat -n 
 2022  mpc
