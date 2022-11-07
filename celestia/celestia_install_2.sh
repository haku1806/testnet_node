#!/bin/sh
# wget -O celestia_install_step1.sh https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_step1.sh && chmod +x celestia_install_step1.sh && ./celestia_install_step1.sh
# sh <(curl https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_step1.sh || wget -O - https://raw.githubusercontent.com/haku1806/testnet_node/main/celestia/celestia_install_step1.sh)
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
                # set vars
                # Save the above created Variables by running this:
                read -p "Enter node name: " CELESTIA_NODENAME
                echo 'export CELESTIA_NODENAME='${CELESTIA_NODENAME} >> $HOME/.bash_profile
                read -p "Enter wallet name: " CELESTIA_WALLET
                echo 'export CELESTIA_WALLET='${CELESTIA_WALLET} >> $HOME/.bash_profile

                CELESTIA_CHAIN="mamaki"
                CELESTIA_PORT=20
                echo 'export CELESTIA_CHAIN='$CELESTIA_CHAIN >> $HOME/.bash_profile
                source $HOME/.bash_profile

                echo '================================================='
                echo -e "Your node name: \e[1m\e[32m$CELESTIA_NODENAME\e[0m"
                echo -e "Your wallet name: \e[1m\e[32m$CELESTIA_WALLET\e[0m"
                echo -e "Your chain name: \e[1m\e[32m$CELESTIA_CHAIN\e[0m"
                echo -e "Your port: \e[1m\e[32m$CELESTIA_PORT\e[0m"
                echo '================================================='
                sleep 2

                # Update & Upgrade OS
                echo -e "\n Update & Upgrade\n"
                sudo apt update && sudo apt upgrade -y 
                # Install library
                echo -e "\n Install library\n"
                sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu -y

                # INSTALL GO
                echo -e "\nInstall GO\n"
                cd $HOME
                ver="1.18.3"
                wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
                sudo rm -rf /usr/local/go
                sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
                rm "go$ver.linux-amd64.tar.gz"
                echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
                source $HOME/.bash_profile
                sleep 2

                # check if GO has been installed successfully 
                if [ "$(go version)" != "" ]; 
                then
                echo -e "\Go installed"
                else
                echo -e "\nError when install Go. Please check again."
                exit 1
                fi

                # 4. INSTALL Celestia App
                cd $HOME
                rm -rf celestia-app
                git clone https://github.com/celestiaorg/celestia-app.git
                cd celestia-app
                git checkout v0.6.0
                make install

                # check if Celestia App has been installed successfully 
                if [ "$(celestia-appd version)" != "" ]; 
                then
                echo -e "\Celestia App installed"
                else
                echo -e "\nError when install Celestia App. Please check again."
                exit 1
                fi

                # if systemctl is-active --quiet celestia-appd then
                #         echo -e "1\n"
                # else 
                #         echo -e "2\n"
                # fi

                git clone https://github.com/celestiaorg/networks

                # 5. Setting up P2P Network :
                cd $HOME
                rm -rf networks
                git clone https://github.com/celestiaorg/networks.git

                # initialize the network
                celestia-appd init $CELESTIA_NODENAME --chain-id $CELESTIA_CHAIN

                # Copy the genesis.json file
                cp $HOME/networks/mamaki/genesis.json $HOME/.celestia-app/config/

                # Setting Up Validator Node
                sed -i 's/mode = \"full\"/mode = \"validator\"/g' $HOME/.celestia-app/config/config.toml

                # Setting up seeds and peers
                BOOTSTRAP_PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/bootstrap-peers.txt | tr -d '\n')

                sed -i.bak -e "s/^bootstrap-peers *=.*/bootstrap-peers = \"$BOOTSTRAP_PEERS\"/" $HOME/.celestia-app/config/config.toml

                sed -i 's/timeout-commit = ".*/timeout-commit = "25s"/g' $HOME/.celestia-app/config/config.toml
                sed -i 's/peer-gossip-sleep-duration *=.*/peer-gossip-sleep-duration = "2ms"/g' $HOME/.celestia-app/config/config.toml

                # 8. Set P2P Configuration Option
                max_num_inbound_peers=40 
                max_num_outbound_peers=10 
                max_connections=50

                sed -i -e "s/^use-legacy *=.*/use-legacy = false/;\
                s/^max-num-inbound-peers *=.*/max-num-inbound-peers = $max_num_inbound_peers/;\
                s/^max-num-outbound-peers *=.*/max-num-outbound-peers = $max_num_outbound_peers/;\
                s/^max-connections *=.*/max-connections = $max_connections/" $HOME/.celestia-app/config/config.toml

                # 9. Configuring pruning and snapshots
                pruning_keep_recent="100" 
                pruning_interval="10"

                sed -i -e "s/^pruning *=.*/pruning = \"custom\"/;\
                s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/;\
                s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.celestia-app/config/app.toml

                # Run this to set snapshot-interval
                sed -i 's/snapshot-interval *=.*/snapshot-interval = 0/' $HOME/.celestia-app/config/app.toml

                # 10. Reset
                celestia-appd tendermint unsafe-reset-all — home $HOME/.celestia-app

                # 11. Configuring Client
                celestia-appd config chain-id $CELESTIA_CHAIN
                celestia-appd config keyring-backend test

                # 12. Creating and Running Services
                tee $HOME/celestia-appd.service > /dev/null <<EOF
                [Unit]
                Description=celestia-appd Cosmos daemon
                After=network-online.target
                [Service]
                User=$USER
                ExecStart=$(which celestia-appd) start
                Restart=on-failure
                RestartSec=3
                LimitNOFILE=65535
                [Install]
                WantedBy=multi-user.target
                EOF

                sudo mv $HOME/celestia-appd.service /etc/systemd/system/
        
                sudo systemctl enable celestia-appd
                sudo systemctl daemon-reload
                sudo systemctl restart celestia-appd && journalctl -u celestia-appd -f -o cat | trap - INT

                # 13. Quick Syncing and Starting Celestia App:
                # Let’s stop celestia-appd by running :
                sudo systemctl stop celestia-appd
                cd $HOME
                rm -rf ~/.celestia-app/data
                mkdir -p ~/.celestia-app/data
                wget -O — https://hakuvnz.hakuvn.workers.dev/0:/Miner/mamaki_2022-11-06.tar | tar xf — \
                -C ~/.celestia-app/data/

                sudo systemctl restart celestia-appd && journalctl -u celestia-appd -f -o cat | trap - INT
                
                # Wallet
                celestia-appd keys add $CELESTIA_WALLET
                # Do store this information in a notepad file.
                # save these values in Variables
                CELESTIA_ADDR=$(celestia-appd keys show $CELESTIA_WALLET -a) 
                echo $CELESTIA_ADDR 
                echo 'export CELESTIA_ADDR='${CELESTIA_ADDR} >> $HOME/.bash_prof
                CELESTIA_VALOPER=$(celestia-appd keys show $CELESTIA_WALLET — bech val -a) 
                echo $CELESTIA_VALOPER 
                echo 'export CELESTIA_VALOPER='${CELESTIA_VALOPER} >> $HOME/.bash_profile 
                source $HOME/.bash_profile

                echo '=============== SETUP FINISHED ==================='
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