sudo apt-get install wget curl expect -y
sudo apt-get update
sudo apt-get install ppp net-tools -y
#sudo apt-get install ppp iproute2 -y
wget http://cdn.software-mirrors.com/forticlientsslvpn_linux_4.4.2328.tar.gz
tar zxvf forticlientsslvpn_linux_4.4.2328.tar.gz
sudo chown root:root ./forti-vpn.sh
sudo chmod 600 ./forti-vpn.sh
sudo chmod +x ./forti-vpn.sh
sudo ./forti-vpn.sh &