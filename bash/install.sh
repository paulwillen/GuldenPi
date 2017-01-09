#basic update
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade

cd /

sudo mkdir /guldenserver
sudo wget https://developer.gulden.com/download/161/Gulden161-linux32.tar.xz -P /guldenserver

sudo tar -xvf /guldenserver/Gulden161-linux32.tar.xz -C /guldenserver/Gulden
sudo mkdir /guldenserver/datadir
sudo touch /guldenserver/datadir/Gulden.conf


echo "disablewallet=1" >> /guldenserver/datadir/Gulden.conf
echo "maxconnections=20" >> /guldenserver/datadir/Gulden.conf

uuiduser=$(uuidgen)
uuidpassword=$(uuidgen)

echo "rpcuser=$uuiduser" >> /guldenserver/datadir/Gulden.conf
echo "rpcpassword=$uuidpassword" >> /guldenserver/datadir/Gulden.conf