#!/bin/bash -x
# 
# REWQ by Omer ARGUN
# A Modern Drupal Develop Platform
#

clear

tput setaf 6
    echo "System is installed. Now initializind all services."
tput sgr0

sleep 1



service nginx restart
service php5-fpm restart
service mysql restart

