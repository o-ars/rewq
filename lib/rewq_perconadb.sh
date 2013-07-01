#!/bin/bash -x
# 
# REWQ by Omer ARGUN
# A Modern Drupal Develop Platform
# install PerconaDB 5.X.X -> 01.07.2013

clear

tput setaf 6
    echo "PerconaDB Installing"
tput sgr0

sleep 1



PACKAGE_1=postfix
dpkg -l $PACKAGE_1 >/dev/null 2>&1 ;

if [  "$?" = 1 ] 
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

	sudo apt-get install -y postfix

	sleep 3

fi



sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
sudo gpg -a --export CD2EFD2A | apt-key add -
sudo echo 'deb http://repo.percona.com/apt precise main' >> /etc/apt/sources.list
sudo echo 'deb-src http://repo.percona.com/apt precise main' >> /etc/apt/sources.list
sudo echo 'Package: *' >> /etc/apt/preferences.d/00percona.pref
sudo echo 'Pin: release o=Percona Development Team' >> /etc/apt/preferences.d/00percona.pref
sudo apt-get update -y
sudo sudo apt-get install -y percona-server-server-5.5 percona-server-client-5.5


PACKAGE_2=mysql
dpkg -l $PACKAGE_2 >/dev/null 2>&1 ;

if [  "$?" = 1 ] 
then
	tput setaf 2
		echo "$PACKAGE_2 installed."
	tput sgr0

	sleep 1

else

	tput setaf 1
		echo "$PACKAGE_2 NOT installed."
		# install package
	tput sgr0

	sleep 3

fi