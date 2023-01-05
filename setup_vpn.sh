sudo apt-get update && \
  apt-get install -y -o APT::Install-Recommends=false -o APT::Install-Suggests=false \
  ca-certificates \
  expect \
  net-tools \
  iproute2 \
  ipppd \
  iptables \
  wget \
  && apt-get clean -q && apt-get autoremove --purge \
  && rm -rf /var/lib/apt/lists/*
sudo apt-get install wget curl expect -y
wget http://cdn.software-mirrors.com/forticlientsslvpn_linux_4.4.2328.tar.gz
tar -xzvf forticlientsslvpn_linux_4.4.2328.tar.gz
sudo apt-get install ppp iproute2 -y
cp ./setup.linux.sh ./forticlientsslvpn/64bit/helper/
sudo chown root:root ./setup.linux.sh
sudo chmod 600 ./setup.linux.sh
sudo chmod +x ./setup.linux.sh
./forticlientsslvpn/64bit/helper/setup.linux.sh 2
sudo chown root:root ./forti-vpn.sh
sudo chmod 600 ./forti-vpn.sh
sudo chmod +x ./forti-vpn.sh
sudo ./forti-vpn.sh &