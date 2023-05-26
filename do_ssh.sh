#!/usr/bin/expect
set PASSWORD [lindex $argv 0]

spawn scp -oControlMaster=no -O -oHostkeyAlgorithms=ssh-rsa -oKexAlgorithms=+diffie-hellman-group1-sha1 /tmp/hosts root@192.168.1.1:/tmp/hosts
expect "password"
send "$PASSWORD\r"
expect eof

spawn ssh -oControlMaster=no -O -oKexAlgorithms=+diffie-hellman-group1-sha1 root@192.168.1.1 "stopservice dnsmasq; startservice dnsmasq"
expect "password"
send "$PASSWORD\r"
expect eof
exit
