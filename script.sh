#!/bin/bash
gpio mode 4 out;
gpio mode 5 out;
gpio write 4 0;
gpio write 5 0;
while : ; do
  read token
  token=$(echo $token | cut -d':' -f2)
  email=$(curl -X GET https://www.googleapis.com/oauth2/v2/userinfo -H 'Authorization: Bearer '$token | jq -r .email)
  count=$(grep $email emails.txt | wc -l)

  if [ $count = 1 ]; then
    gpio write 4 1 ;
    sleep 2 ;
    gpio write 4 0 ;
    curl -H https://accounts.google.com/o/oauth2/revoke?token=$token
  else
    gpio write 5 1 ;
    sleep 2 ;
    gpio write 5 0 ;
  fi
done;