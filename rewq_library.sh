#!/bin/bash -x

#
# oars/rewq
# Modern Drupal Develop Platform
#
#

# Essentials
function rewq_prepare() {

	# Update System
	yum -y update

	# Install Essential Tools
	yum -y install vim wget curl sudo jwhois bind-utils mlocate screen git

	# Set Hostname
	echo "HOSTNAME=$REWQ_HOSTNAME" >> /etc/sysconfig/network
	hostname "$REWQ_HOSTNAME"

	# Set Timezone
	ln -s /usr/share/zoneinfo/$REWQ_TIMEZONE /etc/localtime

}

# Install RPM's / Repositories
function rewq_repos() {

	rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
	rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
	rpm --nosignature -i http://repo.varnish-cache.org/redhat/varnish-3.0/el5/noarch/varnish-release-3.0-1.noarch.rpm
	rpm -Uvh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm

	cat > /etc/yum.repos.d/MariaDB.repo << EOF
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/5.5/centos6-x86
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

	# Update RPMS / Repositories
	yum -y update

}

# Install Nginx Web Server
function rewq_server() {
	yum -y --disablerepo=epel install nginx
}

# Install PHP
function rewq_php() {
	yum -y --enablerepo=remi install php php-fpm php-gd php-mysqlnd php-mbstring php-xml php-mcrypt php-pecl-apc php-pdo
}

# Install Varnish Cache
function rewq_cache() {
	yum -y --disablerepo=epel install varnish
}

# Install MariaDB
function rewq_db() {
	yum -y --disablerepo=epel install MariaDB-server MariaDB-client
}

# Configure Security
function rewq_security() {

	# Create new root user
	adduser $REWQ_ROOT_USER
	echo $REWQ_ROOT_USER_PASSWORD | passwd $REWQ_ROOT_USER --stdin

	# iptables Configuration
	iptables -F
	iptables -t nat -F
	iptables -X
	iptables -P FORWARD DROP
	iptables -P INPUT   DROP
	iptables -P OUTPUT  ACCEPT

	## HTTP (varnish)
	iptables -A INPUT -p tcp --dport 80 -j ACCEPT

	## HTTP (nginx)
	iptables -A INPUT -p tcp --dport 8080 -j ACCEPT

	## HTTPS (SSL) Traffic
	iptables -A INPUT -p tcp --dport 443 -j ACCEPT

	## Local Loopback
	iptables -A INPUT -i lo -p all -j ACCEPT

	# SSH Configuration

	## Disable UseDNS
	sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config

	## Change Default SSH Port
	if [[ -z "$REWQ_SSH_PORT" ]];
		then
			iptables -A INPUT -p tcp --dport 22 -j ACCEPT
		else
			iptables -A INPUT -p tcp --dport $REWQ_SSH_PORT -j ACCEPT
			sed -i 's/#Port 22/Port '"$REWQ_SSH_PORT"'/g' /etc/ssh/sshd_config
	fi

	## Deny / Allow SSH Users
	sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
	echo "$REWQ_ROOT_USER ALL=(ALL:ALL) ALL" >> /etc/sudoers
	echo "AllowUsers $REWQ_ROOT_USER" >> /etc/ssh/sshd_config

	# Networking / Sys Configuration

	## Kernel Hardening
	cp /etc/sysctl.conf /etc/sysctl.conf.bak

	cat > /etc/sysctl.conf << EOF
net.ipv4.ip_forward = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.tcp_max_syn_backlog = 1280
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.tcp_timestamps = 0
EOF

	## Disable IPv6
	echo "NETWORKING_IPV6=no" >> /etc/sysconfig/network
	echo "IPV6INIT=no" >> /etc/sysconfig/network

	## Enable SELinux
	sed -i 's/SELINUX=disabled/SELINUX=enforcing/g' /etc/selinux/config

	## Remove unnecessary Users
	userdel apache && userdel games && userdel gopher && userdel postfix

}

# Configure LEMP Stack
function rewq_configure() {

	# Create LEMP user
	useradd -r -s /sbin/nologin www-data

	# Global Settings
	MEMORY=$(free -m | awk '/^Mem:/{print $2}')
	CPU=$(grep -c ^processor /proc/cpuinfo)

	# PHP-FPM
	## Set Permissions
	sed -i 's/;listen.mode = 0666/listen.mode = 0600/g' /etc/php-fpm.d/www.conf

	## Update User
	sed -i 's/;listen.owner = nobody/listen.owner = www-data/g' /etc/php-fpm.d/www.conf
	sed -i 's/;listen.group = nobody/listen.group = www-data/g' /etc/php-fpm.d/www.conf

	sed -i 's/user = apache/user = www-data/g' /etc/php-fpm.d/www.conf
	sed -i 's/group = apache/group = www-data/g' /etc/php-fpm.d/www.conf

	## Set Listening Socket
	sed -i 's@listen = 127.0.0.1:9000@listen = /var/run/php-fpm.sock@g' /etc/php-fpm.d/www.conf

	## Customise PHP.ini
	sed -i 's/disable_functions =/disable_functions = show_source, passthru, exec, popen, proc_open, allow_url_fopen, allow_url_include/g' /etc/php.ini
	sed -i 's@;date.timezone =@date.timezone = Australia/Sydney@g' /etc/php.ini

	## FastCGI Configuration
	echo "fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;" >> /etc/nginx/fastcgi_params

	# Nginx
	sed -i 's/user  nginx;/user www-data;/g' /etc/nginx/nginx.conf
	sed -i 's/listen       80;/listen 8080;/g' /etc/nginx/conf.d/default.conf

	## Tune Worker Processes & Connections (Not accurate for most para-virtualised systems)
	WP=$(($CPU*2))
	sed -i 's/worker_processes  1;/worker_processes '$WP';/g' /etc/nginx/nginx.conf

	WC=$((1024*$CPU))
	sed -i 's/worker_connections  1024;/worker_connections '$WC';/g' /etc/nginx/nginx.conf

	# Varnish
	## Customise Configuration
	mv /etc/sysconfig/varnish /etc/sysconfig/varnish.bak

	## Get Memory Allocation
	MALLOC=$(($MEMORY*20/100))

	cat > /etc/sysconfig/varnish << EOF
	DAEMON_OPTS="-a :80 \
		-T localhost:6081 \
		-f /etc/varnish/default.vcl \
		-u varnish -g varnish \
		-S /etc/varnish/secret \
		-s malloc,${MALLOC}m"
EOF

	sed -i 's/.port = "80";/.port = "8080";/g' /etc/varnish/default.vcl

	# MariaDB
	## Tune MariaDB Server
	rm -f /etc/my.cnf.d/server.cnf

	if [[ $MEMORY -le 256 ]];
		then
		cp /usr/share/mysql/my-small.cnf /etc/my.cnf.d/server.cnf

	elif [[ $MEMORY -le 512 ]];
		then
		cp /usr/share/mysql/my-medium.cnf /etc/my.cnf.d/server.cnf

	elif [[ $MEMORY -ge 1000 ]];
		then
		cp /usr/share/mysql/my-large.cnf /etc/my.cnf.d/server.cnf
	fi

	## Secure DB and Set Root Password
	service mysql start && sleep 5

    echo "DELETE FROM mysql.user WHERE User='';" | mysql -u root
    echo "DELETE FROM mysql.user WHERE User='root' AND Host!='localhost';" | mysql -u root
    echo "DROP DATABASE test;" | mysql -u root
    echo "UPDATE mysql.user SET Password=PASSWORD('$REWQ_MARIADB_PASSWORD') WHERE User='root';" | mysql -u root
    echo "FLUSH PRIVILEGES;" | mysql -u root

}

# Engage rewq Services
function rewq_engage() {

	# Update Search Index
	updatedb

	# Ensure Services Boot on Startup
	chkconfig --add nginx && chkconfig nginx on
	chkconfig --add php-fpm && chkconfig php-fpm on
	chkconfig --add varnish && chkconfig varnish on
	chkconfig --add mysql && chkconfig mysql on

	# Launch Services
	service nginx restart
	service php-fpm restart
	service varnish restart
	service mysql restart
	service sshd restart

}