#!/bin/bash
# Script that goes trought 'cerrojo.sh' and returns each answer
# Copy each answer and paste it folowed by enter (it will not show anything, but do it)
# You only have to use 'ssh user@ip | ./liberadAW.sh'
# Remember to give execution permission with 'chmod +x liberadAW.sh'
fifo=fifo
mkfifo ${fifo}
exec 3<> ${fifo}
function exit_prog {
   rm ${fifo} 2> /dev/null;
   rm clave{1..3}.priv* clave{1..3}.pub* file{1..5}* key{1..5} 2> /dev/null;
}
trap exit_prog INT

BLUE='\033[0;36m'
NC='\033[0m' # No Color
CLAVE=""
FIRST=0;

while read line; do
   echo -e "${line}";
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

   if [[ $line == *'Tendremos un password'* ]]; then
      COD=`echo $line | cut -d " " -f 9 | cut -d "." -f 1`;
   fi

   if [[ $line == *'Bien, la password cifrada'* ]]; then
      if [[ $line == *'tras haber hecho'* ]]; then
         read line; echo -e "$line";
         COD=`echo $line | cut -d " " -f 10 | cut -d "." -f 1`;
      fi
      read line; echo -e "$line";
      read line2; echo -e "$line2";
      CLAVE=`echo -n $line; echo -n $line2`;

   fi

   if [[ $line == *'Y la clave sim'* ]]; then
      rm clave1.priv clave1.pub 2> /dev/null;
      wget $WEBDIR/clave1.pub 2> /dev/null;
      wget $WEBDIR/clave1.priv 2> /dev/null;
      read line; echo -e "$line";
      read line2; echo -e "$line2";
      read line3; echo -e "$line3";
      PASS=`echo -n $line; echo -n $line2; echo -n $line3`;
      PASS=`echo "$PASS" | openssl enc -base64 -d | openssl rsautl -decrypt -inkey clave1.priv | cut -d " " -f 5`;
      CLAVE=`echo "$CLAVE" | openssl enc -base64 -d | openssl enc -$COD -d -pass "pass:$PASS" | cut -d " " -f 7`;
      echo -e "$BLUE Aquí tienes joven padawan: $CLAVE $NC";
      read line; echo -n $line;
      echo "${CLAVE}" >&3;

    fi

    if [[ $line == *'Para el proceso de firma'* ]]; then
      COD=`echo $line | cut -d " " -f 16`;
      COD=${COD::-1}
    fi

    if [[ $line == *'La firma del fichero 1'*  ]]; then
      rm clave{1..3}.priv clave{1..3}.pub file{1..5} key{1..5} 2> /dev/null;
      wget $WEBDIR/clave{1..3}.pub 2> /dev/null;
      wget $WEBDIR/clave{1..3}.priv 2> /dev/null;
      wget $WEBDIR/file{1..5} 2> /dev/null;
      read line; echo -e "$line"; read line2; echo -e "$line2"; read line3; echo -e "$line3";
      KEY1=`echo -n $line; echo -n $line2; echo -n $line3`;
      echo "$KEY1" | openssl enc -base64 -d > key1
      read line; echo -e "$line"; read line; echo -e "$line";
      read line; echo -e "$line"; read line2; echo -e "$line2"; read line3; echo -e "$line3";
      KEY2=`echo -n $line; echo -n $line2; echo -n $line3`;
      echo "$KEY2" | openssl enc -base64 -d > key2
      read line; echo -e "$line"; read line; echo -e "$line";
      read line; echo -e "$line"; read line2; echo -e "$line2"; read line3; echo -e "$line3";
      KEY3=`echo -n $line; echo -n $line2; echo -n $line3`;
      echo "$KEY3" | openssl enc -base64 -d > key3
      read line; echo -e "$line"; read line; echo -e "$line";
      read line; echo -e "$line"; read line2; echo -e "$line2"; read line3; echo -e "$line3";
      KEY4=`echo -n $line; echo -n $line2; echo -n $line3`;
      echo "$KEY4" | openssl enc -base64 -d > key4
      read line; echo -e "$line"; read line; echo -e "$line";
      read line; echo -e "$line"; read line2; echo -e "$line2"; read line3; echo -e "$line3";
      KEY5=`echo -n $line; echo -n $line2; echo -n $line3`;
      echo "$KEY5" | openssl enc -base64 -d > key5
    fi

    if [[ $line == *'de file1?'* ]]; then
      for i in {1..3}; do
         RET=`openssl dgst -$COD -c -signature key1 -verify clave$i.pub file1` 
         if [[ $RET == *'OK'* ]]; then
            echo "$i" >&3;
         fi
      done
    fi

    if [[ $line == *'de file2?'* ]]; then
      for i in {1..3}; do
         RET=`openssl dgst -$COD -c -signature key2 -verify clave$i.pub file2` 
         if [[ $RET == *'OK'* ]]; then
            echo "$i" >&3;
         fi
      done
    fi
      
    if [[ $line == *'de file3?'* ]]; then
      for i in {1..3}; do
         RET=`openssl dgst -$COD -c -signature key3 -verify clave$i.pub file3` 
         if [[ $RET == *'OK'* ]]; then
            echo "$i" >&3;
         fi
      done
    fi

    if [[ $line == *'de file4?'* ]]; then
      for i in {1..3}; do
         RET=`openssl dgst -$COD -c -signature key4 -verify clave$i.pub file4` 
         if [[ $RET == *'OK'* ]]; then
            echo "$i" >&3;
         fi
      done
    fi

    if [[ $line == *'de file5?'* ]]; then
      for i in {1..3}; do
         RET=`openssl dgst -$COD -c -signature key5 -verify clave$i.pub file5` 
         if [[ $RET == *'OK'* ]]; then
            echo "$i" >&3;
         fi
      done
    fi
   # Skip first steps
   if [[ $line == *'please try'* ]]; then
      echo -e "${line}";
      echo $'\n' >&3;

   fi
   if [[ $line == *'Ahora debes morir.'* ]]; then
      echo -e "${line}";
      echo $'\003' >&3;
      FIRST=-1
   fi
   # Skip false game end
   if [ $FIRST = -1 ]; then
      if [[ $line == *'Ahora adentro y securiza'* ]]; then
         echo -e "${line}";
         echo $'\n\n\n' >&3;
      fi
   fi
   # FINAL
   if [[ $line == *'Bien hecho!!! Ya tienes acceso a tu servidor. No olvides securizarlo corréctamente.'* ]]; then
      echo -e "$BLUE Estos no son los androides que estás buscando... Disfruta del server."
      echo -e "$BLUE Recuerda borrar o cambiar de lugar el fichero cerrojo.sh para que no se vuelva a ejecutar."
      echo "";
      echo -e "$BLUE Vuelve a iniciar con ssh de manera normal."
      echo -e "$BLUE Que la fuerza te acompañe!!$NC";
      echo "";
      echo "";
      echo $'\003' >&3;
      break;
   fi

done < <(ssh -tt $1@$2 <${fifo})
exit_prog
