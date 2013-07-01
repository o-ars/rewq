#!/bin/bash -x
# 
# REWQ by Omer ARGUN
# A Modern Drupal Develop Platform
# install nginx 1.4.1 -> 01.07.2013

clear

tput setaf 6
    echo "NGINX is installing"
tput sgr0

sleep 1

sudo apt-get install  -y python-software-properties

sudo add-apt-repository -y ppa:nginx/stable

sudo apt-get update -y

sudo apt-get install -y nginx

echo "2 - SERVER"

PACKAGE_1=nginx
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