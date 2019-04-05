#!/bin/bash
  
while [ 1 ] 
do
        #1 packets transmitted, 1 received, 0% packet loss, time 0ms
        pr=`ping google.com -c 1 | tail -n2 | head -n 1`
        d=`date +'%Y-%m-%dT%R:%S.%N'`
        hasFailed=0

        if [[ ${#pr} -lt 5 ]]
        then
                json="{'trans':1, 'recv':0, 'dnsfail':true, 'clidate':'$d', 'isdown':true}"
                hasFailed=1
        else
                trans=`echo $pr | cut -d" " -f1`
                recv=`echo $pr | cut -d" " -f4`
                t=`echo $pr | cut -d" " -f10|cut -d"m" -f 1`
                isdown='false'

                if [ $recv -eq 0 ]
                then
                        isdown='true'
                        hasFailed=1
                fi
                json="{'trans':$trans, 'recv':$recv, 'latency':$t, 'clidate':'$d', 'isdown':$isdown, 'dnsfail':false}"
        fi

        json=`echo $json | sed "s/'/\"/g"`
        echo $json>>/home/ubuntu/iscomcastdown.txt

        if [ $hasFailed -eq 1 ]
        then
                echo $json>>/home/ubuntu/iscomcastdown_yes.txt
        else
                echo $json
                curl --header "Content-Type: application/json" --request POST --data "$json" https://us-east-1.aws.webhooks.mongodb-stitch.com/api/client/v2.0/app/plex-wltfx/service/hook/incoming_webhook/comcast
        fi
        sleep 20
done