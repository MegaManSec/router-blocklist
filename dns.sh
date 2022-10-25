#!/bin/bash

NETWORK=Linksys # Wifi AP
TEST_DOM=test.something.com # A domain we use to test using nslookup after we have applied the changes
TEST_IP=1.2.3.4 # An IP which the TEST_DOM will only resolve to if the changes are applied
PASSWORD=password # Password for our router

[[ $(/Sy*/L*/Priv*/Apple8*/V*/C*/R*/airport -I | grep -w SSID | awk '{print $2}') == "$NETWORK" ]] || exit 0 #Only do this if we're connected to $NETWORK
[[ $(nslookup "$TEST_DOM") =~ "$TEST_IP" ]] && exit 0 #If $TEST_DOM already resolves to $TEST_IP, there's nothing for us to do.
[ -f /tmp/dns.tmp ] && exit 0 #Already running, probably means something is wrong with our network.

touch /tmp/dns.tmp

curl 'https://someonewhocares.org/hosts/zero/hosts' --silent -k | grep --color=never  '^0.0.0.0 ' | awk '{print $1" "$2}'  > /tmp/swc
curl 'https://winhelp2002.mvps.org/hosts.txt' --silent -k | grep --color=never  '^0.0.0.0 ' | awk '{print $1" "$2}' > /tmp/wh2
curl 'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts' --silent -k | grep --color=never  '^0.0.0.0 ' | awk '{print $1" "$2}'> /tmp/sbh

cat /tmp/sbh /tmp/swc /tmp/wh2 | tr -d '\r' | sort | uniq > /tmp/hosts

awk -f organize.awk /tmp/hosts > /tmp/hosts.tmp # -i not supported on all systems
mv /tmp/hosts.tmp /tmp/hosts

echo "$TEST_IP $TEST_DOM" >> /tmp/hosts
echo '127.0.0.1 localhost' >> /tmp/hosts
echo '192.168.1.1 DD-WRT' >> /tmp/hosts

./do_ssh.sh "$PASSWORD"

rm /tmp/dns.tmp
exit 0
