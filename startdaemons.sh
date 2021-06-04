#!/usr/bin/env bash
#  Can get rid of writing the diag files when done with development
#rm /etc/network/if-up.d/vars
#ADDR="$(ip -o address|grep 'eno1    inet '|cut -c 17-35|cut -d/ -f1)"
#goto just_recover
#echo $(ps auxf|grep -v grep|grep -c "inotifywait -mr /etc/emails_awaiting/ -e create")
if [[ $(ps auxf|grep -v grep|grep -c "inotifywait -mr /etc/emails_awaiting/ -e create") == 0 ]];then nohup inotifywait -mr /etc/emails_awaiting/ -e create 2>/dev/null|while read path action file; do if [[ "$file" == "recipients.txt" ]];then until cat "$path"content|sudo -u "$(cat "$path"subject.txt|awk '{printf $1}')" mail -s "$(cat "$path"subject.txt)" "$(cat "$path""$file")" 2>/dev/null; do sleep 189;done && [[ -f "$path"attachmentsforremainingemails.txt ]] && while read -r jpgnametoattach;do sudo -u "$(cat "$path"subject.txt|awk '{printf $1}')" /home/homeowner/smtp-cli --server=smtp.gmail.com:587 -4 --user=PUTYOUROWNHERE --pass=PUTYOUROWNHERE $(cat "$path""picturerecipients.txt"|awk -F, '{for (x=1;x<=NF;x++){printf "--to="$x" "}}') --from="$(cat "$path"subject.txt|awk '{printf $1}')"@gwaamc.com --subject="$(cat "$path"subject.txt)" --attach="$jpgnametoattach" 2>/dev/null;done < "$path"namesofjpgstoattach.txt;rm -r "$path" 2>/dev/null;fi;done & fi
#     nohup inotifywait -mr /etc/emails_awaiting/ -e create 2>/dev/null|while read path action file; do if [[ "$file" == "recipients.txt" ]];then until cat "$path"content|sudo -u "$(cat "$path"subject.txt|awk '{printf $1}')" mail -s "$(cat "$path"subject.txt)" "$(cat "$path""$file")" 2>/dev/null; do sleep 189;done && [[ -f "$path"attachmentsforremainingemails.txt ]] && \
#     while read -r jpgnametoattach;do sudo -u "$(cat "$path"subject.txt|awk '{printf $1}')" /home/homeowner/smtp-cli --server=smtp.gmail.com:587 -4 --user=PUTYOUROWNHERE --pass=PUTYOUROWNHER $(cat "$path""picturerecipients.txt"|awk -F, '{for (x=1;x<=NF;x++){printf "--to="$x" "}}') --from="$(cat "$path"subject.txt|awk '{printf $1}')"@gwaamc.com --subject="$(cat "$path"subject.txt)" --attach="$jpgnametoattach" 2>/dev/null;done < "$path"namesofjpgstoattach.txt;rm -r "$path" 2>/dev/null;fi;done &
#We need to write timeout file if it was an event and then rm -r "$path"
#For event files the above line needs to put a timeout file in /home/homeowner/$path where path is gained from the subject line of event files

#also moniitor for new ip during runtime like this to start; must finish the instruction: nohup inotifywait -mr /var/lib/dhcp/ -e create,modify 2>/dev/null|while read path action file; do grep -a1 eno1 $path$file|tail -n1|awk '{print substr($2,0,length($2)-1)}';done &
while [[ "$(ifconfig|grep 'eno1: flags='|grep '<UP,')." == "." ]]; do
   sleep 1
done

if [ -f /etc/network/if-up.d/thisipadd.txt ]; then rm /etc/network/if-up.d/thisipadd.txt; fi
if [ ! -f /etc/network/if-up.d/iplog.txt ]; then touch /etc/network/if-up.d/iplog.txt; fi
touch /etc/network/if-up.d/Enteredipchangescriptdotsh

#printf "$(env|grep 'IFACE=')" > /etc/network/if-up.d/IFACEVAR

#IFACElocal="$(cat /etc/network/if-up.d/IFACEVAR)"
#"$(</etc/network/if-up.d/IFACEVAR)"
#echo "$IFACElocal" > /etc/network/if-up.d/IFACElocalVARechoed
#if [[ "$IFACElocal" == "IFACE=--all" ]]; then
    ADDRnew="$(ip -o address|grep 'eno1    inet '|cut -c 17-35|cut -d/ -f1)"
    echo "$ADDRnew" > /etc/network/if-up.d/thisipadd.txt
    touch /etc/network/if-up.d/EnteredFirstIf
    ADDRold="$(cat /etc/network/if-up.d/iplog.txt)"
    if [ "$ADDRold" != "$ADDRnew" ] || [ "$1." == "-force." ]; then
         touch /etc/network/if-up.d/SendingEmail
#         nohup /home/homeowner/waitthenemailnewipaddress.sh "$ADDRnew" "$ADDRold" &
#         sleep 40
         mailingdirname="/etc/emails_awaiting/ipaddchngmail$(date +%Y%m%d%H%M%S)"
         mailingdirname1="/etc/emails_awaiting/ipaddchngmail$(date +%Y%m%d%H%M%S%S)"
         mailingdirname2="/etc/emails_awaiting/ipaddchngmail$(date +%Y%m%d%H%M%S%S%S)"
         mailingdirname3="/etc/emails_awaiting/ipaddchngmail$(date +%Y%m%d%H%M%S%S%S%S)"
         mailingdirname4="/etc/emails_awaiting/ipaddchngmail$(date +%Y%m%d%H%M%S%S%S%S%S)"
         mailingdirname5="/etc/emails_awaiting/ipaddchngmail$(date +%Y%m%d%H%M%S%S%S%S%S%S)"
         mailingdirname6="/etc/emails_awaiting/ipaddchngmail$(date +%Y%m%d%H%M%S%S%S%S%S%S%S)"
         mkdir "$mailingdirname" 2>/dev/null
#         mkdir "$mailingdirname1" 2>/dev/null
#         mkdir "$mailingdirname2" 2>/dev/null
#         mkdir "$mailingdirname3" 2>/dev/null
#         mkdir "$mailingdirname4" 2>/dev/null
#         mkdir "$mailingdirname5" 2>/dev/null
#         mkdir "$mailingdirname6" 2>/dev/null
         echo "Any requests must come from whitelisted IP addresses.  Remember my birth year may come in handy." > "$mailingdirname/content"
         printf "\nWeb page\n      http://$ADDRnew:1958 \n" >> "$mailingdirname/content"
         echo "Update to IP address $ADDRnew from $ADDRold" > "$mailingdirname/subject.txt"
         if [ "$1." == "-force." ] && [ "$2." != "." ];then
             echo "$2" > "$mailingdirname/recipients.txt"
         else
             cp /home/homeowner/ipaddchngrecipients.txt "$mailingdirname/recipients.txt"
         fi

#         echo "   Dock camera:" > "$mailingdirname1/subject.txt"
#         echo "Low-res video stream" >> "$mailingdirname1/content";printf "\n" >> "$mailingdirname1/content";echo "        rtsp://$ADDRnew:14554/Streaming/channels/102 " >> "$mailingdirname1/content"
#         echo "High-res video stream" >> "$mailingdirname1/content";printf "\n" >> "$mailingdirname1/content";echo "        rtsp://$ADDRnew:14554/Streaming/channels/101 " >> "$mailingdirname1/content"
#         echo "Login" >> "$mailingdirname1/content";printf "\n" >> "$mailingdirname1/content";echo "       http://$ADDRnew:14080 " >> "$mailingdirname1/content"
#         if [ "$1." == "-force." ] && [ "$2." != "." ];then
#             echo "$2" > "$mailingdirname1/recipients.txt"
#         else
#             cp /home/homeowner/ipaddchngrecipients.txt "$mailingdirname1/recipients.txt"
#         fi
#         echo "   Office camera:" > "$mailingdirname2/subject.txt"
#         echo "Low-res video stream" >> "$mailingdirname2/content";printf "\n" >> "$mailingdirname2/content";echo "        rtsp://$ADDRnew:9554/Streaming/channels/102 " >> "$mailingdirname2/content"
#         echo "High-res video stream" >> "$mailingdirname2/content";printf "\n" >> "$mailingdirname2/content";echo "        rtsp://$ADDRnew:9554/Streaming/channels/101 " >> "$mailingdirname2/content"
#         echo "Login" >> "$mailingdirname2/content";printf "\n" >> "$mailingdirname2/content";echo "        http://$ADDRnew:9080 " >> "$mailingdirname2/content"
#         if [ "$1." == "-force." ] && [ "$2." != "." ];then
#             echo "$2" > "$mailingdirname2/recipients.txt"
#         else
#             cp /home/homeowner/ipaddchngrecipients.txt "$mailingdirname2/recipients.txt"
#         fi
#         echo "   East camera:" > "$mailingdirname3/subject.txt"
#         echo "Low-res video stream" >> "$mailingdirname3/content";printf "\n" >> "$mailingdirname3/content";echo "        rtsp://$ADDRnew:6554/Streaming/channels/102 " >> "$mailingdirname3/content"
#         echo "High-res video stream" >> "$mailingdirname3/content";printf "\n" >> "$mailingdirname3/content";echo "        rtsp://$ADDRnew:6554/Streaming/channels/101 " >> "$mailingdirname3/content"
#         echo "Login" >> "$mailingdirname3/content";printf "\n" >> "$mailingdirname3/content";echo "        http://$ADDRnew:6080 " >> "$mailingdirname3/content"
#         if [ "$1." == "-force." ] && [ "$2." != "." ];then
#             echo "$2" > "$mailingdirname3/recipients.txt"
#         else
#             cp /home/homeowner/ipaddchngrecipients.txt "$mailingdirname3/recipients.txt"
#         fi
#         echo "   Southeast camera:" > "$mailingdirname4/subject.txt"
#         echo "Low-res video stream" >> "$mailingdirname4/content";printf "\n" >> "$mailingdirname4/content";echo "        rtsp://$ADDRnew:10554/Streaming/channels/102 " >> "$mailingdirname4/content"
#         echo "High-res video stream" >> "$mailingdirname4/content";printf "\n" >> "$mailingdirname4/content";echo "        rtsp://$ADDRnew:10554/Streaming/channels/101 " >> "$mailingdirname4/content"
#         echo "Login" >> "$mailingdirname4/content";printf "\n" >> "$mailingdirname4/content";echo "        http://$ADDRnew:10080 " >> "$mailingdirname4/content"
#         if [ "$1." == "-force." ] && [ "$2." != "." ];then
#             echo "$2" > "$mailingdirname4/recipients.txt"
#         else
#             cp /home/homeowner/ipaddchngrecipients.txt "$mailingdirname4/recipients.txt"
#         fi
#         echo "   North camera:" > "$mailingdirname5/subject.txt"
#         echo "Low-res video stream" >> "$mailingdirname5/content";printf "\n" >> "$mailingdirname5/content";echo "        rtsp://$ADDRnew:15554/Streaming/channels/102 " >> "$mailingdirname5/content"
#         echo "High-res video stream" >> "$mailingdirname5/content";printf "\n" >> "$mailingdirname5/content";echo "        rtsp://$ADDRnew:15554/Streaming/channels/101 " >> "$mailingdirname5/content"
#         echo "Login" >> "$mailingdirname5/content";printf "\n" >> "$mailingdirname5/content";echo "        http://$ADDRnew:15080 " >> "$mailingdirname5/content"
#         echo  >> "$mailingdirname5/content"
#         echo "Camera login info IP address $ADDRnew from $ADDRold" > "$mailingdirname6/subject.txt"
#         if [ "$1." == "-force." ] && [ "$2." != "." ];then
#             echo "$2" > "$mailingdirname5/recipients.txt"
#         else
#             cp /home/homeowner/ipaddchngrecipients.txt "$mailingdirname5/recipients.txt"
#         fi
#         echo "Camera login credentials for ONVIFER:" > "$mailingdirname6/subject.txt"
#         echo "username=[youngest brother first name in reverse case]123" >> "$mailingdirname6/content"
#         echo "              password is the same as the username but in proper case" >> "$mailingdirname6/content"
##         echo "Camera login info IP address $ADDRnew from $ADDRold" > "$mailingdirname6/subject.txt"
#         if [ "$1." == "-force." ] && [ "$2." != "." ];then
#             echo "$2" > "$mailingdirname6/recipients.txt"
#         else
#             cp /home/homeowner/ipaddchngrecipients.txt "$mailingdirname6/recipients.txt"
#         fi
#The previous cp line creates the specific file that enables the email daemon to take action
#          |mail -s "Update to IP address $ADDRnew from $ADDRold" $(cat /home/homeowner/ipaddchngrecipients.txt) 2>/home/homeowner/mailingfailurereason


            printf "Subject: Update to IP address $ADDRnew from $ADDRold\n\nWeb page\n      http://$ADDRnew:1958 \n"|ssmtp "$(cat "$mailingdirname/recipients.txt")"
            rm "$mailingdirname/*" 2>/dev/null
            rm -d "$mailingdirname" 2>/dev/null


           printf "$ADDRnew" > /etc/network/if-up.d/iplog.txt
    else
        touch /etc/network/if-up.d/NoEmailSent
    fi
[ "$1." == "-force." ] && exit

#just_recover:
nohup socat -T300 TCP4-LISTEN:6080,fork,reuseaddr TCP:192.168.0.11:6080 2>/dev/null &
nohup socat -T300 TCP4-LISTEN:6554,fork,reuseaddr TCP:192.168.0.11:6554 2>/dev/null &
nohup socat -T300 TCP4-LISTEN:9080,fork,reuseaddr TCP:192.168.0.12:9081 2>/dev/null &
nohup socat -T300 TCP4-LISTEN:9554,fork,reuseaddr TCP:192.168.0.12:9554 2>/dev/null &
nohup socat -T300 TCP4-LISTEN:10080,fork,reuseaddr TCP:192.168.0.13:80 2>/dev/null &
nohup socat -T300 TCP4-LISTEN:10554,fork,reuseaddr TCP:192.168.0.13:554 2>/dev/null &
nohup socat -T300 TCP4-LISTEN:14080,fork,reuseaddr TCP:192.168.0.14:7080 2>/dev/null &
nohup socat -T300 TCP4-LISTEN:14554,fork,reuseaddr TCP:192.168.0.14:7554 2>/dev/null &
nohup socat -T300 TCP4-LISTEN:15080,fork,reuseaddr TCP:192.168.0.15:7080 2>/dev/null &
nohup socat -T300 TCP4-LISTEN:15554,fork,reuseaddr TCP:192.168.0.15:7554 2>/dev/null &
nohup socat -T300 TCP4-LISTEN:20080,fork,reuseaddr TCP:192.168.0.100:80 2>/dev/null &
nohup socat -T300 TCP4-LISTEN:20554,fork,reuseaddr TCP:192.168.0.100:81 2>/dev/null &
#BELOW IS:nohup /home/homeowner/bashttpd -s -m 2>/dev/null &
#Consider trying to use nice someday on these lines to ensure their priority
if [[  $(ps auxf|grep -v grep|grep -c ffmpeg.*11\:) == 0 ]];then bash -c 'nohup ffmpeg -nostdin -stimeout 10000000 -rtsp_transport udp -i "rtsp://192.168.0.11:6554/Streaming/channels/101" -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -c:v libx264 -f segment -segment_time 360 -segment_format_options movflags=+faststart -reset_timestamps 1 -avoid_negative_ts 1 -c copy -flags +global_header /var/www/camera_streams/camera_east_driveway/$(date +%Y%m%d-%H%M%S)%d.mp4 > /dev/null 2>/dev/null & ';fi
sleep 1
if [[  $(ps auxf|grep -v grep|grep -c ffmpeg.*\.12\:) == 0 ]];then bash -c 'nohup ffmpeg -nostdin -stimeout 10000000 -rtsp_transport udp -i "rtsp://kERRY123:Kerry123@192.168.0.12:9554/Streaming/channels/101" -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -c:v libx264 -f segment -segment_time 360 -segment_format_options movflags=+faststart -reset_timestamps 1 -avoid_negative_ts 1 -c copy -flags +global_header /var/www/camera_streams/camera_front_parking/$(date +%Y%m%d-%H%M%S)%d.mp4 > /dev/null 2>/dev/null & ';fi
sleep 1
if [[  $(ps auxf|grep -v grep|grep -c ffmpeg.*\.13\:) == 0 ]];then bash -c 'nohup ffmpeg -nostdin -stimeout 10000000 -rtsp_transport udp -i "rtsp://192.168.0.13:554/Streaming/channels/101" -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -c:v libx264 -f segment -segment_time 360 -segment_format_options movflags=+faststart -reset_timestamps 1 -avoid_negative_ts 1 -c copy -flags +global_header /var/www/camera_streams/camera_south_driveway/$(date +%Y%m%d-%H%M%S)%d.mp4 > /dev/null 2>/dev/null & ';fi
sleep 1
if [[  $(ps auxf|grep -v grep|grep -c ffmpeg.*\.14\:) == 0 ]];then bash -c 'nohup ffmpeg -nostdin -stimeout 10000000 -rtsp_transport udp -i "rtsp://192.168.0.14:7554/Streaming/channels/101" -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -c:v libx264 -f segment -segment_time 360 -segment_format_options movflags=+faststart -reset_timestamps 1 -avoid_negative_ts 1 -c copy -flags +global_header /var/www/camera_streams/camera_sw_corner/$(date +%Y%m%d-%H%M%S)%d.mp4 > /dev/null 2>/dev/null & ';fi
sleep 1
if [[  $(ps auxf|grep -v grep|grep -c ffmpeg.*\.15\:) == 0 ]];then bash -c 'nohup ffmpeg -nostdin -stimeout 10000000 -rtsp_transport udp -i "rtsp://192.168.0.15:7554/Streaming/channels/101" -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -c:v libx264 -f segment -segment_time 360 -segment_format_options movflags=+faststart -reset_timestamps 1 -avoid_negative_ts 1 -c copy -flags +global_header /var/www/camera_streams/camera_ne_corner/$(date +%Y%m%d-%H%M%S)%d.mp4 > /dev/null 2>/dev/null & ';fi
sleep 1
if [[  $(ps auxf|grep -v grep|grep -c ffmpeg.*\.100\:) == 0 ]];then nohup bash -c 'while :;do sudo date +%Y_%b_%d_%H:%M:%S.%N|while read stamp;do ffmpeg -i http://192.168.0.100:80/capture -frames:v 1 -y /camera_snapshots/camera_esp32100/100_"$stamp".jpg -c copy /camera_snapshots/camera_esp32100/latest.jpg;done;if [[ $(( $(ls /camera_snapshots/camera_esp32100|wc -l) )) -ge 4000 ]];then rm /camera_snapshots/camera_esp32100/"$(ls -t /camera_snapshots/camera_esp32100|tail -n1)";fi;done' 1>/dev/null 2>/dev/null & fi

#if [[  $(ps auxf|grep -v grep|grep -c ffmpeg.*\.100\:) == 0 ]];then nohup bash -c 'while :;do sudo date +%Y_%b_%d_%H:%M:%S.%N|while read stamp;do ffmpeg -i http://192.168.0.100:80/capture -frames:v 1 -y /camera_snapshots/camera_esp32100/100_"$stamp".jpg -c copy /camera_snapshots/camera_esp32100/latest.jpg;done;done' 1>/dev/null 2>/dev/null & fi



nohup bash -c 'while [ true ];do /home/homeowner/ffmpegcheck;done' 2>/dev/null &

nohup inotifywait -mr /var/www/camera_streams/ -e create 2>/dev/null|while read pathandcamera action file;do if [[ -f "$pathandcamera""$file" ]] && [ "${file%-*}" != "$(date +%Y%m%d)" ] && [ "${file##*.}" == "mp4" ];then currentprocessid=$(ps x|grep -v grep|grep -m1 "$pathandcamera"|awk '{printf $1}');${SHELL} -c "nice -11 $(ps aux|grep -v grep|grep -m1 "$pathandcamera"|awk '{out=$11;lastfield=NF;for (i=12;i<lastfield;i++){out=out" "$i}{printf out" "}}';echo "$pathandcamera$(date +%Y%m%d-)%d.mp4 2>/dev/null &")";kill $currentprocessid;touch /tmp/new_day_no_backup_yet;elif [[ $(($((360 * $(date +%H))) + $((60 * $(date +%M))) + $(date +%S))) -gt 1000 ]] && [[ -f /tmp/new_day_no_backup_yet ]];then rm /tmp/new_day_no_backup_yet;/home/homeowner/backupndaysago 3;fi 1>/dev/null 2>/dev/null & done 1>/dev/null 2>/dev/null &

#cams_active=$(grep -c '^nohup.*streams' /home/homeowner/backupndaysago)
#ls -l --full-time --time-style=+%b" "%d" "%H:%M:%S -t ${URL_PATH%%?mostrecent*}|head -n$((2 * ${$cams_active}))|awk -v cams_needed=$cams_active \
#         'BEGIN {toptencounter=0;}{topten[++toptencounter]=substr($9,1,length($9)-length(array[split($9,array,"/")]));uniques[topten[toptencounter]]++} END {for (element in uniques){activecams++};if(activecams<cams_needed){print "ALERT - ONLY " activecams " OUT OF " cams_needed " CAMERAS ARE BEING RECORDED. IMMEDIATE ATTENTION ADVISED"

nohup inotifywait -mr /home/homeowner/camera_snapshots/ -e create 2>/dev/null|while read path action file; do if [[ $file == "timeout" ]]; then nohup ${SHELL} -c "sleep $(cat $path$file); rm -f $path$file" 2>/dev/null &  fi;done &
nohup inotifywait -mr /camera_snapshots/ -e create 2>/dev/null|while read pathandcamera action file;do if [ -f /home/homeowner"$pathandcamera"timeout ] && [[ ! $(ps auxf|grep -v grep|grep -A2 /home/homeowner"$pathandcamera"|grep sleep) ]];then rm /home/homeowner"$pathandcamera"timeout;fi;if [ -f /home/homeowner/camera_snapshots/timeout ] && [[ ! $(ps auxf|grep -v grep|grep -A2 '/home/homeowner/camera_snapshots/ '|grep sleep) ]];then rm /home/homeowner/camera_snapshots/timeout;fi;times=$(tail -n1 /home/homeowner"$pathandcamera"/events_reqd|awk '{printf $1}');if [[ -z ${file##*MOTION*} ]];then listing="$(ls -ltr $pathandcamera|tail -n$(((times * 2) + 1)))";while [ $(grep -c MOTION <<< "$listing") == $(((times * 2) + 1)) ];do rm $pathandcamera$(tail -n$((times + 1)) <<< "$listing"|head -n1|awk '{print $9}');listing="$(ls -ltr $pathandcamera|tail -n$(((times * 2) + 1)))";done;fi;if [ ! -f /home/homeowner/giveme90seconds ] && [ ! -f /home/homeowner"$pathandcamera"timeout ] && [[ ! -z "${pathandcamera##*/archives/*}" ]] && [ ! -f /home/homeowner/camera_snapshots/timeout ] && (for alertblackouttimestxt in $(cat /home/homeowner"$pathandcamera"alertblackouttimefiles.txt);do cat "$alertblackouttimestxt"|grep -v ^#|awk -v dow=$(date +%w) -v hr=$(date +%H) -v min=$(date +%M) '{if (substr($0,dow+1,1) != " " && ((substr($0,9,2) == hr && substr($0,12,2) <= min) || substr($0,9,2) < hr) && ((substr($0,15,2) == hr && substr($0,18,2) >= min) || substr($0,15,2) > hr) ){exit 1}}' || exit;done);then numofalarmswithintimeframe=0;lsresults="$(ls -lt --full-time "$pathandcamera"|sed 1d|head -n$((times * 2)))";numofalarmswithintimeframe=$(stdbuf -o0 awk '{print $6" "$7}' <<< "$(ls -lt --full-time "$pathandcamera"|sed 1d)"|while read datestamp;do if [[ $(($(date +%s) - $(date +%s -d "$datestamp"))) -le $(tail -n1 /home/homeowner"$pathandcamera"/events_reqd|awk '{printf $2}') ]];then numofalarmswithintimeframe=$((numofalarmswithintimeframe + 1));echo $numofalarmswithintimeframe;else break;fi;done|tail -n1);filenamesofevents="$(head -n$(( numofalarmswithintimeframe < times ? numofalarmswithintimeframe : times )) <<< "$lsresults"|awk -v path=$pathandcamera '{a[i++]=$9} END {for (j=i-1; j>=0;) print path a[j--]}')";numofnonmotionevents=$(grep -cv MOTION <<< "$filenamesofevents");if [[ $numofnonmotionevents -ge 1 ]] && [[ $numofalarmswithintimeframe -ge $times ]] || [[ $numofnonmotionevents -ge $((times / 2)) ]];then echo -e "filenamesofevents=$filenamesofevents" >> /home/homeowner"$pathandcamera"/log;cp /home/homeowner"$pathandcamera"/timeout.desired /home/homeowner"$pathandcamera"/timeout;mailingdirname="/etc/emails_awaiting/eventmail$(date +%Y%m%d%H%M%S)";mkdir "$mailingdirname";newdirname=/links_to_alerting_activity/$(date +%b%d_%H:%M:%S);mkdir $newdirname 2>/dev/null;while read newfilename;do ln -s "${newfilename}" "$newdirname/${newfilename##*/}";done <<< "$filenamesofevents";echo -e "$filenamesofevents" >> "$mailingdirname/attachmentsforremainingemails.txt";cp "$mailingdirname/attachmentsforremainingemails.txt" "$mailingdirname/namesofjpgstoattach.txt";camera="${pathandcamera%%/}";[[ -f /home/homeowner"${camera}"/alias_for_alerts ]] && camera=$(</home/homeowner"$camera"/alias_for_alerts);echo "${camera##*/} $numofalarmswithintimeframe complex events in $(tail -n1 /home/homeowner"$pathandcamera"/events_reqd|awk '{printf $2}') seconds" >> "$mailingdirname/content";cat "$mailingdirname/attachmentsforremainingemails.txt" >> "$mailingdirname/content";echo "from $(ifconfig eno1|head -n2|tail -n1|awk '{printf $2"\n"}') " >> "$mailingdirname/content";cat "$mailingdirname/attachmentsforremainingemails.txt" >> /home/homeowner"$pathandcamera"/log;echo "${camera##*/} $(grep -v -m1 MOTION <<< "$filenamesofevents"|grep -o [A-Z]*[A-Z]_[A-Z]*) $(date)" > "$mailingdirname/subject.txt";cp /home/homeowner/picturerecipients.txt "$mailingdirname/picturerecipients.txt";cp /home/homeowner/eventrecipients.txt "$mailingdirname/recipients.txt";fi;fi;done 1>/dev/null 2>/dev/null &

nohup /home/homeowner/bashttpd -s -m 2>/dev/null &
# ln -s "$pathandcamera""$file" /links_to_alerting_activity/
# nohup bash -c `while :; do for line in $(cat /home/homeowner/eno1tasks.sh|grep -n 'nohup ffmpeg.*192\.168\.0\...\:'|awk -F: '{print $1}');do if [[ $(awk -v linewanted=$line '{if(NR==linewanted){print $1}}' </home/homeowner/eno1tasks.sh|wc -l) -ne 0 ]];then continue;fi;eval "$(cat /home/homeowner/eno1tasks.sh|awk -v linewanted=$line '{if(NR==linewanted || NR-1==linewanted || NR-2==linewanted){print $0}}')";done;sleep 24;done` 1>/dev/null 2>/dev/null &

if [[ $(ps auxf|grep -v grep|grep -c "inotifywait -mr /var/lib/dhcp/ -e create,modify") == 0 ]];then nohup inotifywait -mr /var/lib/dhcp/ -e create,modify 2>/dev/null|while read path action file; do ADDRold="$(cat /etc/network/if-up.d/iplog.txt)";ADDRnew="$(ip -o address|grep 'eno1    inet '|cut -c 17-35|cut -d/ -f1)";if [[ $ADDRold != $ADDRnew ]];then cat "/home/homeowner/ipaddchngrecipients.txt"|while read recipient; do printf "Subject: Update to IP address $ADDRnew from $ADDRold\n\nWeb page\n      http://$ADDRnew:1958 \n"|ssmtp "$recipient";done;echo $ADDRnew > /etc/network/if-up.d/iplog.txt;fi;done & fi
