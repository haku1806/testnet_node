#!/bin/sh
# wget -O celestia_install_step1.sh https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_step1.sh && chmod +x celestia_install_step1.sh && ./celestia_install_step1.sh
# sh <(curl https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_step1.sh || wget -O - https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_step1.sh)
# sh <(curl https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_2.sh || wget -O - https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_2.sh)


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
                echo -e "Check log"
                journalctl -u celestia-appd -f -o cat
                ;;

        "Check Sync")
                echo -e "Check sync"
                curl -s localhost:${CELESTIA_PORT}657/status | jq .result.sync_info
                ;;

        "Request token in Discord)
                echo -e "Request token in Discord"
                ;;

        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done