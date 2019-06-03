#!/bin/bash
    #title          :gw_handler.sh
    #description    :this gateway administration tool provides basic functions as well as a simple terminal based GUI.
    #author         :rektosauruz
    #date           :20193105
    #version        :v2.3
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



if [ "`whoami`" != "root" ]; then 
	echo "Please run as root"
	exit 0
fi




#################################################
#################################################
#################################################
test_data_collection () {

fid=0

while true; do

    ####DETERMINE LOG CACHE SIZE BEFORE EXECTION####
    #sudo /home/pi/single_chan_pkt_fwd/single_chan_pkt_fwd | head -c 777 > /home/pi/noderix_gw/node_log/logs"$fid".txt
    sudo /home/pi/single_chan_pkt_fwd/single_chan_pkt_fwd | head -c 15000 > /home/pi/noderix_gw/node_log/logs"$fid".txt
    fid=$((fid + 1))
    
done

}



test2_log_to_clean_parser () {

count=0

while true; do

ltc="`ls -v /home/pi/noderix_gw/node_log/ | head -1`"

    if [ ! -z "$ltc" ] && [ "`wc -c /home/pi/noderix_gw/node_log/$ltc | awk '{print $1}'`" != "0" ]; then

        sudo cat /home/pi/noderix_gw/node_log/"$ltc" | grep Gelen | cut -d',' -f2-10 > /home/pi/noderix_gw/data_cache/clean"$count".log
        sudo rm /home/pi/noderix_gw/node_log/"$ltc"
        count=$((count + 1))
  
    else    
        sleep 5
    fi

done

}




test2_parser_mqtt () {

while true; do

if [ ! -z "`ls /home/pi/noderix_gw/data_cache`" ]; then
    
    echo "blankline" > streaming.log
   
    current="`ls -v /home/pi/noderix_gw/data_cache/ | head -1`"

    for i in $(cat /home/pi/noderix_gw/data_cache/"$current"); do
        device_id="`echo "$i" | cut -d"," -f1`"
        latitude="`echo "$i" | cut -d"," -f2`"
        longitude="`echo "$i" | cut -d"," -f3`"
        tstmp_hh="`echo "$i" | cut -d"," -f4`"
        (( tstmp_hh += 3 ))
        tstmp_mm="`echo "$i" | cut -d"," -f5`"
        tstmp_ss="`echo "$i" | cut -d"," -f6`"
        panic_bit="`echo "$i" | cut -d"," -f7`"
        speed="`echo "$i" | cut -d"," -f8`"
        battery="`echo "$i" | cut -d"," -f9`"
        output_var="\"uid\":\"$device_id\",\"lat\":\"$latitude\",\"lon\":\"$longitude\",\"ts_hh\":\"$tstmp_hh\",\"ts_mm\":\"$tstmp_mm\",\"ts_ss\":\"$tstmp_ss\",\"pnc\":\"$panic_bit\",\"v\":\"$speed\",\"btt\":\"$battery\""
        echo "$output_var" >> /home/pi/noderix_gw/streaming.log
        echo "$output_var" >> /home/pi/noderix_gw/streaming2.log
    done
    
    sudo rm /home/pi/noderix_gw/data_cache/"$current"        
    python 1_gw_send.py &
    BACK_PID=$!
    wait $BACK_PID


else 
    sleep 5

fi

done

}



test_start_gw () {

test_data_collection &
test2_log_to_clean_parser &
test2_parser_mqtt &
wait

}



start_one_two () {
    
test2_parser_mqtt &
test_data_collection &
test2_log_to_clean_parser & 
    
    
}

#################################################
#################################################
#################################################




#################################################
#################################################


test_connection() {

testv=`ping -c 1 -w 1 8.8.8.8 | grep ttl`
    if [ -z "$testv" ];
        then
        echo "Internet Connection is ${RED}DOWN${RESET}"
        sleep 1
        return 1
    else
        echo "Internet Connection is ${GREEN}UP${RESET}"
        sleep 1
        return 1
    fi

}



Ipv4_chk() {
#echo "your IP is ${GREEN}`ifconfig wlp3s0 | grep "inet " | cut -d't' -f2 | cut -d'n' -f1`${RESET}"
echo "your IP is ${GREEN}`ifconfig wlan0 | grep "inet " | cut -d't' -f2 | cut -d'n' -f1`${RESET}"
sleep 3
return 1
}



scan_LAN_devices() {

echo "${GREEN}`arp -a`${RESET}" 
sleep 3

}



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
    `echo -e "${RED}                                   |_| v2.3        ${RESET}"`
    ${GREEN}============================================================${RESET}
    |${GREEN}[-1-] Get-data(node)${RESET}   |||${GREEN}[-7-] WAN-access${RESET} |||${RED}[-n-] N-A ${RESET} |   
    |${GREEN}[-2-] Parse-data${RESET}       |||${GREEN}[-8-] Ipv4-check${RESET} |||${RED}[-v-] N-A${RESET}  |  
    |${GREEN}[-3-] Send-data(cloud)${RESET} |||${GREEN}[-9-] LAN-scan  ${RESET} |||${RED}[-a-] N-A${RESET}  |
    |${GREEN}[-4-] Initiate-Process${RESET} |||${RED}[-l-] N-A${RESET}        |||${RED}[-c-] N-A${RESET}  |
    |${RED}[-5-] N-A ${RESET}             |||${RED}[-w-] N-A${RESET}        |||${RED}[-s-] N-A${RESET}  |
    |${GREEN}[-6-] N-A${RESET}              |||${RED}[-d-] N-A${RESET}        |||${RED}[-p-] N-A${RESET}  |  
    |${RED}[-f-] N-A${RESET}              |||${RED}[-g-] N-A${RESET}        |||${RED}[---] N-A${RESET}  |
  ${RED}(q)uit${RESET}${GREEN}========================================================${RESET}
    
EOF
##################!  MENU  !##################



read -n1 -s
    case "$REPLY" in

    "1")  test_data_collection ;;
    "2")  test2_log_to_clean_parser ;;
    "3")  test2_parser_mqtt ;;
    "4")  test_start_gw ;;
#    "5")  sha256 ;;
    "6")  start_one_two ;;
    "7")  test_connection ;; 
    "8")  Ipv4_chk  ;;  
    "9")  scan_LAN_devices ;; 
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
