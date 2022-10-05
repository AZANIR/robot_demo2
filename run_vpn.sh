#!/bin/bash

# Forticlient SSL VPN Client / expect

# --------------------------------------------
# CONFIGURATION


FORTICLIENT_PATH="./forticlientsslvpn/64bit/forticlientsslvpn_cli"

# VPN Credentials
VPN_HOST="65.229.28.150:4443"
VPN_USER="lmayevskyi"
VPN_PASS="ct}DH>!3jW~8R*2<"

# --------------------------------------------

# /opt/forticlient-sslvpn/64bit/forticlientsslvpn_cli --server hostname:443 --vpnuser username --keepalive
#

trap ctrl_c INT

function ctrl_c() {
  echo "Removing left-over files..."
  rm -f /tmp/expect
}

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

if [ -z "$FORTICLIENT_PATH" ]; then
  FORTICLIENT_PATH=`uname -a | grep -q 64 && echo $(locate forticlientsslvpn_cli | grep 64bit) || echo $(locate forticlientsslvpn_cli | grep 32bit)`
  if [ ! -f $FORTICLIENT_PATH ]; then
    echo "Tried to locate Forticlient SSL VPN Cli binary, but failed."
    echo "Specify it at variable FORTCLIENT_PATH"
    exit 1
  fi
  echo "Located Forticlient VPN Client at: $FORTICLIENT_PATH"
fi

echo "Killing previous instances of Forticlient SSL VPN client..."
killall -9 $(basename $FORTICLIENT_PATH) 2> /dev/null


cat << EOF > /tmp/expect
#!/usr/bin/expect -f
match_max 1000000
set timeout -1
spawn $FORTICLIENT_PATH --server $VPN_HOST --vpnuser $VPN_USER --keepalive
expect "Password for VPN:"
send -- "$VPN_PASS"
send -- "\r"

expect "Would you like to connect to this server? (Y/N)"
send -- "Y"
send -- "\r"

expect "Tunnel closed"
close

expect "Clean up..."
close
EOF

chmod 500 /tmp/expect
/usr/bin/expect -f /tmp/expect

rm -f /tmp/expect