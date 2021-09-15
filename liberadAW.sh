#!/bin/bash
# Script that goes trought 'cerrojo.sh' and returns each answer
# Copy each answer and paste it folowed by enter (it will not show anything, but do it)
# You only have to use 'ssh user@ip | ./liberadAW.sh'
# Remember to give execution permission with 'chmod +x liberadAW.sh'
fifo=fifo
mkfifo ${fifo}
exec 3<> ${fifo}
function exit_prog {
   rm ${fifo};
   exit;
}
trap exit_prog INT

BLUE='\033[0;36m'
NC='\033[0m' # No Color
CLAVE=""

while read line; do
   echo -e "$line"
   if [[ $line == *'Bien hecho!!! Ya tienes'* ]]
   then
      break;
   fi
   # First encoding
   if [[ $line == *'dámelo'* ]] 
   then
      read line;
      echo -e "$line";
      CLAVE=`echo "$line" | openssl enc -base64 -d`;
      echo -e "$BLUE Aquí tienes joven padawan: $CLAVE $NC";
      echo "${CLAVE}" >&3;
   fi
   # Hashing stage
   if [[ $line == *'el hash'* ]]
   then
      COD=`echo $line | cut -d " " -f 7`
      CLAVE=`echo -n $CLAVE | openssl dgst -$COD | cut -d " " -f 2`;
      echo -e "$BLUE Aquí tienes joven padawan: $CLAVE $NC";
      echo "${CLAVE}" >&3;
   fi
   if [[ $line == *'y como password'* ]]
   then
      COD=`echo $line | cut -d " " -f 7`
      PASS=`echo $line | cut -d " " -f 11 | cut -d "." -f 1`
      read line; echo -e "$line";
      read line; echo -e "$line";
      read line; echo -e "$line";
      read line2; echo -e "$line2";
      CLAVE=`echo -n $line; echo -n $line2`;
      CLAVE=`echo "$CLAVE" | openssl enc -base64 -d | openssl enc -$COD -d -pass "pass:$PASS" | cut -d " " -f 7`;
      echo -e "$BLUE Aquí tienes joven padawan: $CLAVE $NC";
      read line; echo -n $line;
      echo "${CLAVE}" >&3;
   fi
done < <(ssh -tt $1@$2 <${fifo})
exit_prog
