#!/bin/sh
# wget -O celestia_install_step1.sh https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_step1.sh && chmod +x celestia_install_step1.sh && ./celestia_install_step1.sh
# sh <(curl https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_step1.sh || wget -O - https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_step1.sh)
# sh <(curl https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_2.sh || wget -O - https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_2.sh)


PS3='Please enter your choice: '
options=("Option 1" "Option 2" "Option 3" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Option 1")
            echo "you chose choice 1"
            ;;
        "Option 2")
            echo "you chose choice 2"
            ;;
        "Option 3")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done