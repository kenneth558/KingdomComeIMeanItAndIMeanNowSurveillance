#!/usr/bin/env bash
ADDRold="$(cat /etc/network/if-up.d/iplog.txt)"
timeout 0.130 curl icanhazip.com > /etc/network/if-up.d/iplog.txt 2> /dev/null || timeout 0.130 curl ipecho.net > /etc/network/if-up.d/iplog.txt 2> /dev/null || timeout 0.130 curl ipinfo.io/ip > /etc/network/if-up.d/iplog.txt 2> /dev/null || timeout 0.130 curl ifconfig.me > /etc/network/if-up.d/iplog.txt 2> /dev/null || timeout 0.130 curl api.ipify.org > /etc/network/if-up.d/iplog.txt 2> /dev/null || timeout 0.130 curl bot.whatismyipaddress.com > /etc/network/if-up.d/iplog.txt 2> /dev/null
ADDRnew="$(cat /etc/network/if-up.d/iplog.txt)"
if [ "$ADDRold" != "$ADDRnew" ]; then
      mailingdirname="/etc/emails_awaiting/ipaddchngmail$(date +%Y%m%d%H%M%S)"
      mkdir "$mailingdirname" 2>/dev/null
      cp /home/homeowner/ipaddchngrecipients.txt "$mailingdirname/recipients.txt"
      printf "Subject: Update to IP address $ADDRnew from $ADDRold\n\nWeb page\n      http://$ADDRnew:1958 \n"|ssmtp "$(cat "$mailingdirname/recipients.txt")"
      rm "$mailingdirname/*" 2>/dev/null
      rm -d "$mailingdirname" 2>/dev/null
fi
