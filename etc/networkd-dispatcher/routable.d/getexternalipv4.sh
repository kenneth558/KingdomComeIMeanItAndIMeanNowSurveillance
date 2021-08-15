#!/usr/bin/env bash
#next line is nothing more than possibly useful for troubleshooting
touch /etc/networkd-dispatcher/routable.d/IFACEVAR
#next line make whatever the name of the external interface is
while [[ "$(ifconfig|grep 'eno1: flags='|grep '<UP,')." == "." ]]; do
   sleep 1
done

if [ ! -f /etc/networkd-dispatcher/routable.d/iplog.txt ]; then touch /etc/networkd-dispatcher/routable.d/iplog.txt; fi

printf "${IFACE}," >> /etc/networkd-dispatcher/routable.d/IFACEs
printf "$(env|grep 'IFACE=')" > /etc/networkd-dispatcher/routable.d/IFACEVAR
IFACElocal="$(</etc/networkd-dispatcher/routable.d/IFACEVAR)"
#IFACE=eno1
#next line is from previous version of OS.  Does it work now?  Time will tell
if [[ "${IFACElocal#IFACE=}" == "eno1" ]]; then
   ADDRold="$(grep -m 1 -Eo "([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5]).([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5]).([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5]).([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])" /etc/networkd-dispatcher/routable.d/iplog.txt)"
   timeout 0.130 curl icanhazip.com > /etc/networkd-dispatcher/routable.d/iplog.txt 2> /dev/null || timeout 0.130 curl ipecho.net > /etc/networkd-dispatcher/routable.d/iplog.txt 2> /dev/null || timeout 0.130 curl ipinfo.io/ip > /etc/networkd-dispatcher/routable.d/iplog.txt 2> /dev/null || timeout 0.130 curl ifconfig.me > /etc/networkd-dispatcher/routable.d/iplog.txt 2> /dev/null || timeout 0.130 curl api.ipify.org > /etc/networkd-dispatcher/routable.d/iplog.txt 2> /dev/null || timeout 0.130 curl bot.whatismyipaddress.com > /etc/networkd-dispatcher/routable.d/iplog.txt 2> /dev/null
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
