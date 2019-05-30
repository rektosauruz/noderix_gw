#!/bin/bash
    #title          :gw_handler.sh
    #description    :this gateway administration tool provides basic functions as well as a simple terminal based GUI.
    #author         :rektosauruz
    #date           :20193005
    #version        :v1.5
    #usage          :./gw_handler.sh
    #notes          :size limit must be set for the primary data chunk, check for line 49.
    #bash_version   :4.4-5
    #================================================================================


### | Declerations          | ====================================================#
# Color Declerations
#ESC="["
#RESET=$ESC"39m"
#RED=$ESC"31m"
#GREEN=$ESC"32m"
#LBLUE=$ESC"36m"
#BLUE=$ESC"34m"
#BLACK=$ESC"30m"
#YELLOW=$ESC"33m"



ESC="["
RESET=$ESC"39m"
RED=$ESC"31m"
GREEN=$ESC"32m"
LYELLOW=$ESC"36m"
YELLOW=$ESC"34m"
YELLOW=$ESC"33m"
RB=$ESC"48;5;160m"
RESET1=$ESC"0m"
RESETU=$ESC"24m"
GB=$ESC"48;5;40m"





#################################################
#################################################
#################################################
test_data_collection () {

fid=0

while true; do

    ####DETERMINE LOG CACHE SIZE BEFORE EXECTION####
    sudo /home/pi/single_chan_pkt_fwd/single_chan_pkt_fwd | head -c 777 > /home/pi/noderix_gw/node_log/logs"$fid".txt
    
    fid=$((fid + 1))
    
done

}



test_log_to_clean_parser () {

count=0

while true; do

ltc="`ls /home/pi/noderix_gw/node_log/ | head -1`"

    if [ ! -z "$ltc" ]; then

        sudo cat /home/pi/noderix_gw/node_log/"$ltc" | grep Gelen | cut -d',' -f2-10 > /home/pi/noderix_gw/data_cache/clean"$count".log
        sudo rm /home/pi/noderix_gw/node_log/"$ltc"
        count=$((count + 1))
    else
        #break
        echo "${RED}waiting for data collection ##${RESET} ${GREEN}logs(#).txt${RESET} ${RED}files are not created ##${RESET}"
    fi

done

}




test_parser_mqtt () {

#/home/omnivoid/Desktop/clean/pre_production/data_cache/

while true; do

current="`ls /home/pi/noderix_gw/data_cache/ | head -1`"

    if [ ! -z "$current" ]; then

        for i in $(cat /home/pi/noderix_gw/data_cache/"$current"); do
          device_id="`echo "$i" | cut -d"," -f1`"
          latitude="`echo "$i" | cut -d"," -f2`"
          longitude="`echo "$i" | cut -d"," -f3`"
          tstmp_hh="`echo "$i" | cut -d"," -f4`"
          tstmp_mm="`echo "$i" | cut -d"," -f5`"
          tstmp_ss="`echo "$i" | cut -d"," -f6`"
          panic_bit="`echo "$i" | cut -d"," -f7`"
          speed="`echo "$i" | cut -d"," -f8`"
          battery="`echo "$i" | cut -d"," -f9`"
          output_var="\"uid\":\"$device_id\",\"lat\":\"$latitude\",\"lon\":\"$longitude\",\"ts_hh\":\"$tstmp_hh\",\"ts_mm\":\"$tstmp_mm\",\"ts_ss\":\"$tstmp_ss\",\"pnc\":\"$panic_bit\",\"v\":\"$speed\",\"btt\":\"$battery\""
          echo "$output_var" >> /home/pi/noderix_gw/streaming.log
        done

    python 1_gw_send.py
    truncate -s 0 /home/pi/noderix_gw/streaming.log
    sudo rm /home/pi/noderix_gw/data_cache/"$current"

    else
        echo "${RED}waiting for data collection ##${RESET} ${GREEN}clean(#).log ${RESET}${RED} files are not created ##${RESET}"
    fi

done

}



test_start_gw () {

test_data_collection &
test_log_to_clean_parser &
test_parser_mqtt &

}

#################################################
#################################################
#################################################



##################!  MENU  !##################
while :
do
    clear
    cat<<EOF
    `echo -e "${RED}                 _           _      _  ______        __ ${RESET}"`
    `echo -e "${RED} _ __   ___   __| | ___ _ __(_)_  _| |/ ___\ \      / /${RESET}"`
    `echo -e "${RED}| '_ \ / _ \ / _  |/ _ \ '__| \ \/ / | |  _ \ \ /\ / /${RESET}"`
    `echo -e "${RED}| | | | (_) | (_| |  __/ |  | |>  <| | |_| | \ V  V /${RESET}"`
    `echo -e "${RED}|_| |_|\___/ \__,_|\___|_|  |_/_/\_\ |\____|  \_/\_/${RESET}"`
    `echo -e "${RED}                                   |_| v1.1        ${RESET}"`
    ${GREEN}========================================================${RESET}
    |${GREEN} [001] Get-data(node)${RESET}  ||| ${GREEN}[007] N-A${RESET}   ||| ${GREEN}[00n] N-A ${RESET} |   
    |${GREEN} [002] Parse-data${RESET}		||| ${GREEN}[008] N-A${RESET}   ||| ${GREEN}[00v] N-A${RESET}  |  
    |${GREEN} [003] Send-data(cloud)${RESET}||| ${GREEN}[009] N-A${RESET}   ||| ${GREEN}[00a] N-A${RESET}  |
    |${GREEN} [004] Initiate-Process${RESET}||| ${GREEN}[00l] N-A${RESET}   ||| ${GREEN}[00c] N-A${RESET}  |
    |${GREEN} [005] N-A ${RESET}            ||| ${GREEN}[00w] N-A${RESET}   ||| ${GREEN}[00s] N-A${RESET}  |
    |${GREEN} [006] N-A${RESET}             ||| ${GREEN}[00d] N-A${RESET}   ||| ${GREEN}[00p] N-A${RESET}  |  
    |${GREEN} [00f] N-A${RESET}             ||| ${GREEN}[00g] N-A${RESET}   ||| ${GREEN}[---] N-A${RESET}  |
  ${RED}(q)uit${RESET}${GREEN}====================================================${RESET}
    
EOF
##################!  MENU  !##################



read -n1 -s
    case "$REPLY" in

    "1")  test_data_collection ;;
    "2")  test_log_to_clean_parser ;;
    "3")  test_parser_mqtt ;;
    "4")  test_start_gw ;;
#    "5")  sha256 ;;
#    "6")  tar_archiever ;;
#    "7")  test_function ;; 
#    "8")  scan_last_two  ;;  
#    "9")  test_connection ;; 
#    "l")  Ipv4_chk ;;
#    "a")  echo "invalid option" ;;
#    "c")  echo "invalid option"1 ;;  
#    "v")  echo "invalid option" ;;
#    "w")  who_is ;;
#    "s")  ssh_connect ;;
#    "p")  echo "invalid option" ;;
#    "d")  echo "invalid option" ;;
#    "n")  test_while_run ;;
#    "f")  sha256chk ;;
#    "g")  md5chk ;;
    "q")  exit                      ;;
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
