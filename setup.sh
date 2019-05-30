#!/bin/bash
    #title          :setup.sh
    #description    :setup tool for gw_handler.sh
    #author         :rektosauruz


#Color Declerations
ESC="["
RESET=$ESC"39m"
RED=$ESC"31m"
GREEN=$ESC"32m"
LYELLOW=$ESC"36m"
YELLOW=$ESC"34m"
YELLOW=$ESC"33m"
RB=$ESC"48;5;160m"
RESET1=$ESC"0m"




##check for root
if [[ "${EUID}" -ne 0 ]]; then
  echo -e "${GREEN}run${RESET} ${RED}setup.sh${RESET} ${GREEN}with${RESET} ${RED}root !${RESET}"
  exit 1
fi


#### CREATING REQUIRED FOLDERS

sudo mkdir data_cache
sudo mkdir node_log


#### CREATING REQUIRED FILES
sudo touch streaming.log


#### SETTING R-W-E
sudo chmod 777 data_cache/
sudo chmod 777 node_log/
sudo chmod 777 streaming.log
