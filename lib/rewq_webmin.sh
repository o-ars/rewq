#!/bin/bash -x
# 
# REWQ by Omer ARGUN
# A Modern Drupal Develop Platform
#

sudo apt-get install -y perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python
cd /tmp
sudo wget http://prdownloads.sourceforge.net/webadmin/webmin_1.630_all.deb
sudo dpkg --install webmin_1.630_all.deb
cd -

clear

tput setaf 6
    echo "STEP"
tput sgr0

sleep 1



# DO SOMETHING

PACKAGE_1=webmin

dpkg -l $PACKAGE_1 >/dev/null 2>&1 ;



if [  "$?" = 0 ] 
then
	tput setaf 2
		echo "$PACKAGE_1 installed."
	tput sgr0

	sleep 1

else

	tput setaf 1
		echo "$PACKAGE_1 NOT installed."
		# install package
	tput sgr0

	sleep 3

fi