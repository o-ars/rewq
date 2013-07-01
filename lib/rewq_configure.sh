#!/bin/bash -x
# 
# REWQ by Omer ARGUN
# A Modern Drupal Develop Platform
#



clear

tput setaf 6
    echo "Configuring the Services"
tput sgr0

sleep 1



updatedb



# Ensure Services Boot on Startup
chkconfig --add nginx && chkconfig nginx on
chkconfig --add php-fpm && chkconfig php-fpm on
chkconfig --add mysql && chkconfig mysql on
chkconfig --add webmin && chkconfig webmin on
