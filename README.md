# router-blocklist

The internet is unusable without some sort of ad-blocker. However, adblockers do not work on all systems and applications (e.g. on iPhone).

In order to block malware and ads, we null-route domains which are known to serve things we don't want to use up our bandwidth.

This script downloads blocklists, parses them for an /etc/hosts file, then uploads them to a DD-WRT router.

## Variables

In `dns.sh`, there are various variables at the top of the file that need to be set.

## DNS Alternatives

Note: this works best when DNS over TLS and DNS over HTTPS is blocked (i.e. ports 853 and 443 over UDP) respectively. Blocking UDP on port 443 may cause unknown consequences:
```
iptables -I FORWARD -p tcp --dport 853 -j DROP
iptables -I FORWARD -p udp --dport 443 -j DROP
```
Some browsers may not function after the above change, so check the settings to disable DNS over TLS (for example) in them.

## Note

Instead of using an ssh key to interact with the router, the password used directly.
This is because the alternative is saving the passcode to our SSH key somewhere -- we want this script to run without _any_ interaction by the user (i.e. even if the key hasn't been added to the keychain).

This script is run on a computer connected to the router, rather than the router itself, because my router does not have wget nor curl installed, and there is no way to easily download files from websites. Hence this hacky-solution!

The SSH confirm `-oKexAlgorithms=+diffie-hellman-group1-sha1` is used because my router (and thus DD-WRT version) is extremely old.
