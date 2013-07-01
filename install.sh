#!/bin/bash -x

#
# oars/rewq
# Modern Drupal Develop Platform
#
#

# Create Global Options

## Hostname Option
REWQ_HOSTNAME="host.domain.com"

## Timezone Option
REWQ_TIMEZONE="Australia/NSW"

## Custom SSH Option
REWQ_SSH_PORT="3636"

## New Root User
REWQ_ROOT_USER="sudoninja"

## Root User Password
REWQ_ROOT_USER_PASSWORD="sudoninjapassword"

## MariaDB Root Password
REWQ_MARIADB_PASSWORD="mariadbpassword"

(

# Retrieve REWQ Library
. rewq_library.sh

# Run rewq Installer
rewq=(
	'rewq_prepare'
	'rewq_repos'
	'rewq_server'
	'rewq_php'
	'rewq_cache'
	'rewq_db'
	'rewq_security'
	'rewq_configure'
	'rewq_engage'
)

for i in "${rewq[@]}"
do
	echo -e '\E[37;44m'"\033[1m [$i] Running $i \033[0m"
	$i
	wait
done

) 2>&1 | tee /var/log/stackscript.log