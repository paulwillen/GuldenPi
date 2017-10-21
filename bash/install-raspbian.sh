#!/bin/sh

# make directory for uuid-runtime
mkdir /run/uuid

#basic update & install ufw (firewall) and uuid-runtime (for uuid functions)
apt-get -y --force-yes update
apt-get -y --force-yes upgrade
apt-get -y --force-yes install ufw uuid-runtime

############ Download & install Gulden Software ######

cd /

mkdir /guldenserver
wget https://github.com/Gulden/gulden-official/releases/download/v1.6.4.6/Gulden-1.6.4.6-arm-linux-eabihf.tar.gz -P /guldenserver

tar -xvf /guldenserver/Gulden-1.6.4.6-arm-linux-eabihf.tar.gz -C /guldenserver/
mkdir /guldenserver/datadir
rm -rf /guldenserver/datadir/Gulden.conf
touch /guldenserver/datadir/Gulden.conf


echo "disablewallet=1" >> /guldenserver/datadir/Gulden.conf
echo "maxconnections=20" >> /guldenserver/datadir/Gulden.conf 

uuiduser=$(uuidgen)
uuidpassword=$(uuidgen)

echo "rpcuser=$uuiduser" >> /guldenserver/datadir/Gulden.conf
echo "rpcpassword=$uuidpassword" >> /guldenserver/datadir/Gulden.conf

########  Set correct values for the firewall ###############

ufw allow ssh
ufw allow 9231
ufw enable

#####  Run the Gulden Application ####

/guldenserver/GuldenD -datadir=/guldenserver/datadir &

############# Create autorun file ####
rm -rf /guldenserver/run.sh
touch /guldenserver/run.sh
echo "#!/bin/bash -" >> /guldenserver/run.sh
echo "killall -9 GuldenD" >> /guldenserver/run.sh
echo "rm -rf /guldenserver/peers.dat" >> /guldenserver/run.sh
echo "./guldenserver/GuldenD -datadir=./guldenserver/datadir &" >> /guldenserver/run.sh
chmod 744 /guldenserver/run.sh

############# Create GuldenD Service ####

rm -rf /etc/systemd/system/GuldenD.service
touch /etc/systemd/system/GuldenD.service
echo "[Unit]" >> /etc/systemd/system/GuldenD.service
echo "Description=GuldenD Full Node" >> /etc/systemd/system/GuldenD.service
echo "After=network.target" >> /etc/systemd/system/GuldenD.service
echo "[Service]" >> /etc/systemd/system/GuldenD.service
echo "Type=forking" >> /etc/systemd/system/GuldenD.service
echo "ExecStart=/guldenserver/run.sh" >> /etc/systemd/system/GuldenD.service
echo "[Install]" >> /etc/systemd/system/GuldenD.service
echo "WantedBy=default.target" >> /etc/systemd/system/GuldenD.service
chmod 664 /etc/systemd/system/GuldenD.service
systemctl daemon-reload
systemctl enable GuldenD.service

#############  Check for raspi-config & Expand filesystem  #############

if [ "$(whoami)" != "root" ]; then
  whiptail --msgbox "Sorry you are not root. You must type: sudo sh install.sh" $WT_HEIGHT $WT_WIDTH
  exit
fi

sudo raspi-config --expand-rootfs
exit
