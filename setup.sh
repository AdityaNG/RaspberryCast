#!/bin/sh

if [ `id -u` -ne 0 ]
then
  echo "Please start this script with root privileges!"
  echo "Try again with sudo."
  exit 0
fi

cat /etc/debian_version | grep 7. > /dev/null
if [ "$?" = "1" ]
then
  echo "This script was designed to run on Rasbian or a similar Debian 7.x distro!"
  echo "Do you wish to continue anyway?"
  while true; do
    read -p "" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo "Please answer with Yes or No [y|n].";;
    esac
  done
  echo ""
fi

echo "This script will install RaspberryCast"
echo "Do you wish to continue?"

while true; do
  read -p "" yn
  case $yn in
      [Yy]* ) break;;
      [Nn]* ) exit 0;;
      * ) echo "Please answer with Yes or No [y|n].";;
  esac
done
echo ""
echo "============================================================"
echo ""
echo "Installing necessary dependencies... (This could take a while)"
echo ""
echo "============================================================"
apt-get update

if [ "$?" = "1" ]
then
  echo "An unexpected error occured!"
  exit 0
fi

apt-get upgrade -y

if [ "$?" = "1" ]
then
  echo "An unexpected error occured!"
  exit 0
fi

apt-get install lsof x11-xserver-utils python-pip git wget omxplayer
echo "============================================================"

if [ "$?" = "1" ]
then
  echo "An unexpected error occured!"
  exit 0
fi

pip install youtube-dl Flask requests

if [ "$?" = "1" ]
then
  echo "An unexpected error occured!"
  exit 0
fi

echo ""
echo "============================================================"
echo ""
echo "Cloning project..."
echo ""
echo "============================================================"

git clone https://github.com/vincent-lwt/RaspberryCast.git

echo ""
echo "============================================================"
echo ""
echo "Installing Node & Peerflix (takes a while)..."
echo ""
echo "============================================================"
echo ""
echo "Downloading node.js..."

wget -q http://node-arm.herokuapp.com/node_latest_armhf.deb > /dev/null

if [ "$?" = "1" ]
then
  echo "An unexpected error occured while downloading!"
  exit 0
fi

echo ""
echo "Installing node.js..."

sudo dpkg -i node_latest_armhf.deb > /dev/null

if [ "$?" = "1" ]
then
  echo "An unexpected error occured!"
  exit 0
fi

rm node_latest_armhf.deb > /dev/null

echo ""
echo "Installing Peerflix..."

echo "============================================================"
npm install -g peerflix
echo "============================================================"

if [ "$?" = "1" ]
then
  echo "An unexpected error occured!"
  exit 0
fi

echo "============================================================"
echo "Setup was successful!"
echo "Do not delete the 'RaspberryCast' folder as it contains all application data!"
echo "REBOOTING..."
echo "============================================================"

sleep 4
reboot
exit 0