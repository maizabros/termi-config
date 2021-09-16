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

   if [[ $line == *'En el directorio'* ]]; then
      DIREC=`echo $line | cut -d " " -f 4`;
      WEBDIR="http://$2/$DIREC";
      rm clave1.priv clave1.pub 2> /dev/null;
      wget $WEBDIR/clave1.pub 2> /dev/null;
      wget $WEBDIR/clave1.priv 2> /dev/null;
   fi

   if [[ $line == *'es el siguiente:'* ]]; then
      read line; echo -e "$line";
      read line2; echo -e "$line2";
      read line3; echo -e "$line3";
      CLAVE=`echo -n $line; echo -n $line2; echo -n $line3`;
      CLAVE=`echo "$CLAVE" | openssl enc -base64 -d | openssl rsautl -decrypt -inkey clave1.priv | cut -d " " -f 7`;
      echo -e "$BLUE Aquí tienes joven padawan: $CLAVE $NC";
      echo "${CLAVE}" >&3;

   fi

   # Skip first steps
   if [[ $line == *'please try'* ]]; then
      echo -e "${line}";
      echo $'\n' >&3;

   fi
   if [[ $line == *'Ahora debes morir.'* ]]; then
      echo -e "${line}";
      echo $'\003' >&3;
   fi

done < <(ssh -tt $1@$2 <${fifo})
exit_prog
