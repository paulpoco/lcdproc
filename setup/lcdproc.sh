[program:start-script]
autorestart = false
startsecs = 0
user = root
command = /root/start.sh

[program:lcdproc-script]
autorestart = false
startsecs = 0
user = nobody
command = /home/nobody/lcdproc.sh
