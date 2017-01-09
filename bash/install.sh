#basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

cd /

sudo mkdir /guldenserver
sudo wget https://developer.gulden.com/download/161/Gulden161-linux32.tar.xz -P /guldenserver

sudo tar -xvf /guldenserver/Gulden161-linux32.tar.xz -C /guldenserver/
sudo mkdir /guldenserver/datadir
sudo touch /guldenserver/datadir/Gulden.conf


echo "disablewallet=1" >> /guldenserver/datadir/Gulden.conf
echo "maxconnections=20" >> /guldenserver/datadir/Gulden.conf

uuiduser=$(uuidgen)
uuidpassword=$(uuidgen)

echo "rpcuser=$uuiduser" >> /guldenserver/datadir/Gulden.conf
echo "rpcpassword=$uuidpassword" >> /guldenserver/datadir/Gulden.conf


########  Set correct values for the firewall ###############

sudo ufw allow ssh
sudo ufw allow 9231
sudo ufw enable


#####  Run the Gulden Application ####

./guldenserver/Gulden-1.6.1-i686-linux/GuldenD -datadir=./guldenserver/datadir &


############# Create autorun file ####


sudo touch /guldenserver/run.sh
echo "killall -9 GuldenD" >> /guldenserver/run.sh
echo "rm -rf /guldenserver/seeddata/peers.dat" /guldenserver/run.sh
echo "./guldenserver/Gulden-1.6.1-i686-linux/GuldenD -datadir=./guldenserver/datadir &" >> /guldenserver/run.sh