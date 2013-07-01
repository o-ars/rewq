#!/bin/bash -x
# 
# REWQ by Omer ARGUN
# A Modern Drupal Develop Platform
#

#Prepare the Platform
function rewq_prepare() {
	sudo apt-get autoremove -y
	sudo apt-get remove -y mysql* apache*
	sudo apt-get update -y
	sudo apt-get install -y chkconfig 

}
	
# Install NGINX 1.2.7 Web Server
function rewq_server() {
	sudo apt-get install  -y python-software-properties
	 sudo add-apt-repository -y ppa:nginx/stable
	 sudo apt-get update -y
	 sudo apt-get install -y nginx
	#sudo apt-get install libpcre3 libpcre3-dev
	#sudo dpkg -i nginx_1.4.0-5_amd64.deb

}

# Install PERCONA DB 5.5.30 + MYSQLTUNER
function rewq_db() {
	sudo apt-get install -y postfix
	gpg --keyserver hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
	gpg -a --export CD2EFD2A | apt-key add -
	echo 'deb http://repo.percona.com/apt precise main' >> /etc/apt/sources.list
	echo 'deb-src http://repo.percona.com/apt precise main' >> /etc/apt/sources.list
	echo 'Package: *' >> /etc/apt/preferences.d/00percona.pref
	echo 'Pin: release o=Percona Development Team' >> /etc/apt/preferences.d/00percona.pref
	sudo apt-get install -y percona-server-server-5.5 percona-server-client-5.5 mysqltuner
	
}

# Install PHP 5.4.14 FPM + APC + Extensions
function rewq_php() {
	sudo add-apt-repository -y ppa:ondrej/php5
	sudo apt-get update -y
	sudo apt-get install -y php5-common php5-mysql php5-xmlrpc php5-curl php5-gd php5-fpm php-apc php-pear php5-dev php5-imap php5-mcrypt

}

#Install WEBMIN + VIRTUALMIN
function rewq_panel() {
	
	#Install WEBMIN 1.6.20
	sudo apt-get install -y perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python
	# sudo wget http://prdownloads.sourceforge.net/webadmin/webmin_1.620_all.deb
	sudo dpkg --install webmin_1.620_all.deb

	#INSTALL VIRTUALMIN
	sudo wget http://software.virtualmin.com/gpl/scripts/install.sh
	sudo chmod u+x install.sh
	sudo ./install.sh
	sudo apt-get install -y webmin-virtualmin-nginx webmin-virtualmin-nginx-ssl

}

# Install DRUSH 5.9 + DRUPAL 7.22
function rewq_drupal() {
	sudo apt-get install -y drush
	sudo drush dl drush --destination='/usr/share'
	
}

# Install Other Services; Git - MC - Guard - SOLR - PhpMyAdmin
function rewq_other() {
clear
}

# Install VARNISH + REDIS
function rewq_cache() {
clear
}

# Configure Security Issues; Disable Admin SSH + Ports + ...
function rewq_security() {
clear
}


# Configure & Communicate Services 
function rewq_configure() {
clear
}

# Finish the Installation & Ready to Develop
function rewq_init() {
	updatedb

	# Ensure Services Boot on Startup
	chkconfig --add nginx && chkconfig nginx on
	chkconfig --add php-fpm && chkconfig php-fpm on
	chkconfig --add mysql && chkconfig mysql on
	chkconfig --add webmin && chkconfig webmin on

	# Launch Services
	service nginx restart
	service php-fpm restart
	service mysql restart

}