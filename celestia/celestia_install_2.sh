#!/bin/sh
# wget -O celestia_install_step1.sh https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_step1.sh && chmod +x celestia_install_step1.sh && ./celestia_install_step1.sh
# sh <(curl https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_step1.sh || wget -O - https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_step1.sh)
# sh <(curl https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_2.sh || wget -O - https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_2.sh)
OUTPUT=$(cat /etc/*release)
if echo $OUTPUT | grep -q "Ubuntu 20.04" ; then
        echo -e "\nDetecting Ubuntu 20.04...\n"
        SERVER_OS="Ubuntu20"
else
    if  echo $OUTPUT | grep -q "CentOS Linux 7" ; then
            echo -e "\nDetecting Centos 8...\n"
    elif echo $OUTPUT | grep -q "CentOS Linux 8" ; then
            echo -e "\nDetecting Centos 8...\n"
    elif echo $OUTPUT | grep -q "CloudLinux 7" ; then
            echo -e "\nDetecting CloudLinux 7...\n"
    elif echo $OUTPUT | grep -q "AlmaLinux 8" ; then
            echo -e "\nDetecting AlmaLinux 8...\n"
    elif echo $OUTPUT | grep -q "Rocky Linux" ; then 
            echo -e "\nDetecting Rocky Linux...\n"
    elif echo $OUTPUT | grep -q "Ubuntu 18.04" ; then
            echo -e "\nDetecting Ubuntu 18.04...\n"
    elif echo $OUTPUT | grep -q "Ubuntu 22.04" ; then
            echo -e "\nDetecting Ubuntu 22.04...\n"
    else
            echo -e "\nUnable to detect your OS...\n"
    fi
    echo -e "Celedes is supported on Ubuntu 20.04\n"
    exit 1
fi


PS3='Please enter your choice: '
options=(
"Install Node" 
"Check Log" 
"Check Sync"
"Request token in Discord" 
"Quit"
)
select opt in "${options[@]}"
do
    case $opt in
        "Install Node")
                # Snapshoot version number
                echo -e "\nSnapshoot version number 2022-11-06."
                # INIT SETTINGS
                echo -e "\nInit wallet config\nExample:\n CELESTIA_NODENAME=\"DuhItsAniketNode\"\nCELESTIA_WALLET=\"DuhItsAniketWallet\"\nCELESTIA_CHAIN=\"mamaki\"\n\n"
                
                # echo '=============== SETUP FINISHED ==================='
                ;;

        "Check Log")
                journalctl -u celestia-appd -f -o cat
                ;;

        "Check Sync")
                curl -s localhost:${CELESTIA_PORT}657/status | jq .result.sync_info
                ;;

        "Request token in Discord)
                echo "========================================================================================================================"
                echo "You can request from Mamaki Testnet Faucet on the #faucet channel on Celestia's Discord server with the following command: $request <CELESTIA_ADDR>"
                echo "========================================================================================================================"
                ;;

        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
done