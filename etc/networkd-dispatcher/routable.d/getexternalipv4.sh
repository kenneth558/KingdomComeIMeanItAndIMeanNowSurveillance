#!/usr/bin/env bash
#next line is nothing more than possibly useful for troubleshooting
touch /etc/networkd-dispatcher/routable.d/IFACEVAR
EXTERNAL_INTERFACE=$(route|grep default|awk '{print $NF}')
printf "${EXTERNAL_INTERFACE}" > /etc/networkd-dispatcher/routable.d/EXTERNAL_INTERFACE
#next line -  Does it work?  Time will tell
while [[ "$(ifconfig|grep '"${EXTERNAL_INTERFACE}": flags='|grep '<UP,')." == "." ]]; do
   sleep 1
done

if [ ! -f /etc/networkd-dispatcher/routable.d/iplog.txt ]; then touch /etc/networkd-dispatcher/routable.d/iplog.txt; fi

printf "${IFACE}," >> /etc/networkd-dispatcher/routable.d/IFACEs
printf "$(env|grep 'IFACE=')" > /etc/networkd-dispatcher/routable.d/IFACEVAR
IFACElocal="$(</etc/networkd-dispatcher/routable.d/IFACEVAR)"
#next line is from previous version of OS.  Does it work now?  Time will tell
if [[ "${IFACElocal#IFACE=}" == "${EXTERNAL_INTERFACE}" ]]; then
   ADDRold="$(grep -m 1 -Eo "([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5]).([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5]).([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5]).([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])" /etc/networkd-dispatcher/routable.d/iplog.txt)"
#the following are sorted by millisecond metric for their typical teim of execution, least to greatest.  Example of measuring statement:
#date +%N > /tmp/starttime;curl icanhazip.com &> /dev/null;date +%N > /tmp/endtime;echo $(( $(cat /tmp/endtime) - $(cat /tmp/starttime) ))
   timeout 0.130 curl icanhazip.com > /etc/networkd-dispatcher/routable.d/iplog.txt 2> /dev/null || \
timeout 0.130 curl ipecho.net > /etc/networkd-dispatcher/routable.d/iplog.txt 2> /dev/null || \
timeout 0.130 curl ipinfo.io/ip > /etc/networkd-dispatcher/routable.d/iplog.txt 2> /dev/null || \
timeout 0.130 curl ifconfig.me > /etc/networkd-dispatcher/routable.d/iplog.txt 2> /dev/null || \
timeout 0.130 curl api.ipify.org > /etc/networkd-dispatcher/routable.d/iplog.txt 2> /dev/null || \
timeout 0.130 curl bot.whatismyipaddress.com > /etc/networkd-dispatcher/routable.d/iplog.txt 2> /dev/null
   ADDRnew="$(grep -m 1 -Eo "([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5]).([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5]).([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5]).([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])" /etc/networkd-dispatcher/routable.d/iplog.txt)"
   if [ "$ADDRold" != "$ADDRnew" ]; then
      mailingdirname="/etc/emails_awaiting/ipaddchngmail$(date +%Y%m%d%H%M%S)"
      mkdir "$mailingdirname" 2>/dev/null
      cp /home/homeowner/ipaddchngrecipients.txt "$mailingdirname/recipients.txt"
      printf "Subject: Update to IP address $ADDRnew from $ADDRold\n\nWeb page\n      http://$ADDRnew:1958 \n"|ssmtp "$(cat "$mailingdirname/recipients.txt")"
      rm "$mailingdirname/*" 2>/dev/null
      rm -d "$mailingdirname" 2>/dev/null
   fi
fi
if [[ $(ps auxf|grep -v grep|grep -c "/home/homeowner/ffmpegcheck") == 0 ]];then nohup bash -c 'while [ true ];do /home/homeowner/ffmpegcheck;done' 2>/dev/null &  fi
