#!/bin/bash
#
# oars/rewq
# REWQ is an Installer
# Modern Drupal Develop Platform
#
#
# Create Global Options

        ## New Root User
        #REWQ_ROOT_USER="ninja"

        ## Root User Password
        #REWQ_ROOT_USER_PASSWORD="ninjapass"

        ## MariaDB Root Password
        #REWQ_MARIADB_PASSWORD="dbpass"
        #sh rewq_lib/rewq_prepare.sh

        ## Hostname Option
        # KURUL_HOSTNAME="host.drupaldevelop.com"

        ## Timezone Option
        # KURUL_TIMEZONE="Europe/Istanbul"

        ## Custom SSH Option
        # KURUL_SSH_PORT="3636"

        ## New Root User
        # KURUL_ROOT_USER="drupaldeveloper"

        ## Root User Password
        # KURUL_ROOT_USER_PASSWORD="vagrant"

        ## MariaDB Root Password
        # KURUL_MARIADB_PASSWORD="susam"

#if hash apache 2>/dev/null; then
#        tput setaf 2
#        echo "OK"
#        tput sgr0
#else
#        tput setaf 1
#        echo "ERROR"
#        tput sgr0
#fi

function func_prepare {
sh lib/rewq_prepare.sh
}

function func_nginx {
sh lib/rewq_nginx.sh
}

function func_percona {
sh lib/rewq_perconadb.sh
}

function func_php {
sh lib/rewq_php.sh
}

function func_phpmyadmin {
sh lib/rewq_phpmyadmin.sh
}

function func_drush {
sh lib/rewq_drush.sh
}

function func_webmin {
sh lib/rewq_webmin.sh
}

function func_security {
sh lib/rewq_security.sh
}

function func_configure {
sh lib/rewq_configure.sh
}

function func_init {
sh lib/rewq_init.sh
}

whiptail --title " 7 GATES ------- REWQ Installer" --checklist --separate-output "Choose:" 20 60 15 \
"PREPARE" "Preparing the system" on \
"SERVER" "1.4.0" on \
"DB" "5.5.X" on \
"PHP" "5.4.X + FPM + APC x.x.x" on \
"DB_ADMIN" "PhpMyAdmin X.X.X" on \
"DRUSH" "Drush 5.9" on \
"PANEL" "Webmin 1.630" on \
"SECURITY" "Iptables" on \
"CONFIGURE" "Configure Services" on 2>results

while read choice       
do
        case $choice in
                PREPARE) func_prepare
                ;;                
                SERVER) func_nginx
                ;;
                DB) func_percona
                ;;
                PHP) func_php
                ;;
                DB_ADMIN) func_phpmyadmin
                ;;
                DRUSH) func_drush
                ;;
                PANEL) func_webmin
                ;;
                CONFIGURE) func_configure
                ;;
                SECURITY) func_security
                ;;
                *)
                ;;
        esac
done < results

 sh lib/rewq_init.sh

tput setaf 2
        echo "SYSTEM READY...Let's start develop :)))"
tput sgr0