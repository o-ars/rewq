#!/bin/bash -x
# 
# REWQ by Omer ARGUN
# A Modern Drupal Develop Platform
#

clear
tput setaf 6
    echo "preparing"
tput sgr0
sleep 1



sudo apt-get autoremove -y



PACKAGE_1=apache
dpkg -l $PACKAGE_1 >/dev/null 2>&1 ;

if [  "$?" = 0 ] 
then
	tput setaf 1
		echo "$PACKAGE_1 installed before and will be removed."
	tput sgr0
	
	sleep 2
	
	sudo apt-get remove -y apache*
	
else
	tput setaf 2
		echo "$PACKAGE_1 NOT installed"
		# install package
	tput sgr0
fi

PACKAGE_2=mysql
dpkg -l $PACKAGE_2 >/dev/null 2>&1 ;

if [  "$?" = 0 ] 
then
	tput setaf 1
		echo "$PACKAGE_2 installed before and will be removed."
	tput sgr0
		
	sleep 2

	sudo apt-get remove -y mysql*

else
	tput setaf 2
		echo "$PACKAGE_2 NOT installed before and will be install."
		# install package
	tput sgr0
fi

sudo apt-get update -y

sudo apt-get install -y chkconfig

tput setaf 2
	echo "System is ready for install rewq"
tput sgr0

sleep 2 