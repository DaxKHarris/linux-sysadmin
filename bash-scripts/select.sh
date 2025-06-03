#!/bin/bash


cat <<EOF
USER       PID  CPU  MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  22584  3120 ?        Ss   10:15   0:02 /sbin/init
root       234  0.1  0.3  67840 12340 ?        Ss   10:16   0:01 /usr/lib/systemd/systemd-journald
dax        544  2.5  1.2 236000 25600 tty1     Sl+  10:20   1:10 /usr/bin/firefox
dax        590  0.3  0.8 132000 17200 tty1     S    10:22   0:12 /usr/bin/code
root       602  0.0  0.1  18120  2480 ?        S    10:22   0:00 /usr/sbin/cron
dax        730  0.7  0.6 114000 12400 tty1     Sl   10:25   0:25 /usr/bin/htop
nobody     811  0.0  0.0   5000   512 ?        S    10:27   0:00 /usr/sbin/dnsmasq
EOF
