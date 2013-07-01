#!/bin/bash -x
# 
# REWQ by Omer ARGUN
# A Modern Drupal Develop Platform
#



clear

tput setaf 6
    echo "DRUSH installing"
tput sgr0

sleep 1



sudo apt-get install -y drush
sudo drush dl -y drush --destination='/usr/share'



PACKAGE_1=drush

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