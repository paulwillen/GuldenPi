#basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

cd /

sudo mkdir /guldenserver
sudo wget https://github.com/Gulden/gulden-official/releases/download/v1.6.3/Gulden-1.6.3-arm-linux-gnueabihf.tar.gz -P /guldenserver

sudo tar -xvf /guldenserver/Gulden-1.6.3-arm-linux-gnueabihf.tar.gz -C /guldenserver/
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

./guldenserver/Gulden-1.6.3/bin/GuldenD -datadir=./guldenserver/datadir &


############# Create autorun file ####

sudo touch /guldenserver/run.sh
echo "killall -9 GuldenD" >> /guldenserver/run.sh
echo "rm -rf /guldenserver/peers.dat" >> /guldenserver/run.sh
echo "./guldenserver/Gulden-1.6.3/bin/GuldenD -datadir=./guldenserver/datadir &" >> /guldenserver/run.sh
