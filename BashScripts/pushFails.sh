#!/bin/bash
  
#1 packets transmitted, 1 received, 0% packet loss, time 0ms
pr=`ping google.com -c 1 | tail -n2 | head -n 1`
trans=`echo $pr | cut -d" " -f1`
recv=`echo $pr | cut -d" " -f4`

if [ $recv -eq 1 ]
then
        cat /home/ubuntu/iscomcastdown_yes.txt | while read line
        do
                curl --header "Content-Type: application/json" --request POST --data "$line" https://us-east-1.aws.webhooks.mongodb-stitch.com/api/client/v2.0/app/plex-wltfx/service/hook/incoming_webhook/comcast
        done
        >/home/ubuntu/iscomcastdown_yes.txt
fi