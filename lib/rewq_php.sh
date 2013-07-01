#!/bin/bash -x
# 
# REWQ by Omer ARGUN
# A Modern Drupal Develop Platform
# install PHP 5.4.17RC1 -> 01.07.2013

clear

tput setaf 6
    echo "PHP is installing"
tput sgr0

sleep 1

sudo add-apt-repository -y ppa:ondrej/php5
sudo apt-get update -y
sudo apt-get install -y php5-common php5-mysql php5-xmlrpc php5-curl php5-gd php5-fpm php-apc php-pear php5-dev php5-imap php5-mcrypt



PACKAGE_1=php

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

	sleep 3

fi