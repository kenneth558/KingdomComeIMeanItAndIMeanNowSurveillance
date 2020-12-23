# Web-Page-to-play-back-Surveillance-Recordings-and-be-alerted

I had to develop this - a web page and some server-side scripting for personal use.  The cameras in my system are all IP cameras that only output the stream in rtsp, not the newer streaming protocols, so this web page is not set up for live views.  If your camera live streams come to you as a newer http protocol, just modify this and add some video elements where you want them. The server runs Ubuntu 20.04 (not included here) and the web server is lightweight bash scripting forked from bashttpd and tricked out (included here). **bashttpd takes the place of Apache or nginx to serve this web page** .  Alerts are sent by email from the server to as many recipient destinations as desired which is expected to include SMS/MMS translator[s] for alerting via cell phone messaging.

NOTE: My cameras stream files are segmented to 6 minute segments by ffmpeg whose command line is in eno1tasks.sh startup script.  They are recorded at all times continuously regardless of whether events occur or not.
NOTE: Alerting of events is configured via emails sent out.  For this functionality you'll need to hard code some email account name with password in this scripting in eno1tasks.sh.  Please create a dedicated email account for this.
NOTE: Most features require server-side customizations to the http server script (included).  Most functionality will be lost if this page is served without using the tricked out bashttpd script serving this page to do it.

Please don't expect this page to radiate impressive beauty, but it does do me a world of good in functionality such as -
  - accept week long predictable "don't wake me up" time windows as files both per camera and system-wide.  Events in the form of .jpg files will continue to be recorded as .jpgs when they happen so you can research later if you missed anything, they just won't produce alerts.
  - play a sound repeatedly when an alert is sent out

There is room for improvement if you want to: the playback synchronizing algorithm only synchronizes the recorded streams to one place - the very beginning of playback of an event you're researching.  As those streams play, they will lose synchronization due to small unpredictable signal acquisition outages and so forth.
