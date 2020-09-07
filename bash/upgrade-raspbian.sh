#!/bin/sh

# Stop the running GuldenD Service
echo "[$(date)] Stopping GuldenD service" 
systemctl stop GuldenD.service
echo "[$(date)] GuldenD service stopped" 

############ Download & install Gulden Software Update ######

echo "[$(date)] Removing old Gulden download" 
rm -f /guldenserver/*.tar.gz
echo "[$(date)] Downloading new Gulden software from github" 
wget https://github.com/Gulden/gulden-official/releases/download/v2.2.0.12/Gulden-2.2.0.12-arm-linux-eabihf.tar.gz -P /guldenserver
echo "[$(date)] Download completed, now unpacking Gulden software" 
tar -xvf /guldenserver/Gulden-2.2.0.12-arm-linux-eabihf.tar.gz -C /guldenserver/

# Start the GuldenD Service
echo "[$(date)] Unpacking done, starting up GuldenD service" 
systemctl start GuldenD.service
echo "[$(date)] GuldenD service started, upgrade complete"  
exit
