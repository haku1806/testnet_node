#!/bin/bash

while true
do

# Logo

echo "========================================================================================================================"
curl -s https://raw.githubusercontent.com/StakeTake/script/main/logo.sh | bash
echo "========================================================================================================================"

# Menu

PS3='Select an action: '
options=(
"Install Node"
"Check Log"
"Check balance"
"Request tokens in discord"
"Create Validator"
"Exit")
select opt in "${options[@]}"
do
case $opt in

"Install Node")
echo "============================================================"
echo "Install start"
echo "============================================================"
echo "Setup NodeName:"
echo "============================================================"
read NODENAME
echo "============================================================"
echo "Setup WalletName:"
echo "============================================================"
read WALLETNAME
echo export NODENAME=${NODENAME} >> $HOME/.bash_profile
echo export WALLETNAME=${WALLETNAME} >> $HOME/.bash_profile
echo export CHAIN_ID=mamaki >> $HOME/.bash_profile
source ~/.bash_profile

#UPDATE APT
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

#INSTALL GO
rm -r /usr/local/go
rm -r /usr/lib/go-1.13
wget https://golang.org/dl/go1.18.1.linux-amd64.tar.gz; \
rm -rv /usr/local/go; \
tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz && \
rm -v go1.18.1.linux-amd64.tar.gz && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile && \
source ~/.bash_profile && \
go version

cd $HOME
rm -rf $HOME/celestia-app $HOME/.celestia-app
#INSTALL
git clone https://github.com/celestiaorg/celestia-app
cd celestia-app
git fetch
git checkout v0.6.0
make install

celestia-appd init $NODENAME --chain-id $CHAIN_ID
celestia-appd config chain-id $CHAIN_ID


echo "============================================================"
echo "Be sure to write down the mnemonic!"
echo "============================================================"
#WALLET
celestia-appd keys add $WALLETNAME

celestia-appd unsafe-reset-all --home $HOME/.celestia-app
rm $HOME/.celestia-app/config/genesis.json
wget -O $HOME/.celestia-app/config/genesis.json "https://github.com/celestiaorg/networks/raw/master/mamaki/genesis.json"

PEERS="d541469b73bf72d3a51b1d9d63f0f6e5ba50cd52@65.108.208.50:36500,cd1524191300d6354d6a322ab0bca1d7c8ddfd01@95.216.223.149:37770,5273f0deefa5f9c2d0a3bbf70840bb44c65d835c@80.190.129.50:58484,e151b6f494aa0f503a2d8da5e6daf78ec5ff8dab@185.229.119.123:34950,f953efd4a29e4dbee52924b1ccef96a5060dfc4f@135.181.199.224:39868,43e9da043318a4ea0141259c17fcb06ecff816af@141.94.73.39,13e773f70a4ad3ad31f3d905daf67b671b2b8796@167.86.103.158:26656,45d8b18cc8875d458c5201c7a491a4ea782da002@161.97.142.218:26656,7145da826bbf64f06aa4ad296b850fd697a211cc@176.57.189.212:37656,c380645b14ed906b4ef915c33da2aa8e4ca8f89c@167.235.71.35:26656,1d5f32e1b162b7dd289dce98fbf59fcb1cd916ba@195.201.168.245:41584,216d9791a69c8f4ea05967904c929a33c01a0691@142.132.232.41:57102,ea6a6f8075db7c886ea7d4f72757b80e220a4846@45.94.58.221:40620,7dd792ff914f7ad341244958815647a8b853f663@135.181.252.34:52134,a46bbdb81e66c950e3cdbe5ee748a2d6bdb185dd@161.97.168.77,72b34325513863152269e781d9866d1ec4d6a93a@65.108.194.40:26676,5b962fad71a95eb433bf29154e70c53c02977a42@65.108.201.15:26677,320671196f14703230f7677978ea0a11ad77fba8@65.21.142.104:37472,7676c23ca63126b65718c2b4019a41d1d2fa31da@65.108.48.157:26656,ee3fb180eb6bae5a8faca7a2c63b514f59c9517e@65.21.245.146:26656,9c73a68d6e3dbd22b2c8db1bd34c46afcb12b5f0@159.89.8.0:36388,193d29f0dd62d4d89a74b1babebbced8664b6f46@65.21.53.237:26656,37c9f6a1589f06ef108a6dc7b278b6f17f116fe3@190.2.155.67:26656,96cbb38bb8a1cdac71685255c9567e56cc180bcf@45.85.146.235:26656,b8623978b6b6d53d001f1fdfd62b5fc67ebfddb2@164.68.113.198:26656,584f2af633087ad6f0c7285b56d664ffd6d3f351@51.195.233.194:26656,000ccedb64b6a3d4dceee2b19a47b949adb824ef@91.229.245.19:26656,1404e02ae9464492c385252ff604e47f6c64edf7@116.203.120.148:26656,f7b68a491bae4b10dbab09bb3a875781a01274a5@65.108.199.79:20356,b83de313bf06e82148b49d455cc1a88a39dc9558@178.141.155.181:26656,dc536d691d0cdd14a56df735d5236202a8bd0687@65.108.72.175:27656,2f9b577801a108468ae595e45c0f703cf0eb0874@65.108.244.28:26656,bf199295d4c142ebf114232613d4796e6d81a8d0@159.69.110.238:2665,fe2025284ad9517ee6e8b027024cf4ae17e320c9@198.244.164.11:51606,e4429e99609c8c009969b0eb73c973bff33712f9@141.94.73.39:43656,53297689023addd19ec20b9fe48e180ac0cf8780@135.181.254.169:26656,a973b1fafdb7ce5e29bfc340cb7db0d353083d08@65.108.222.5:26656,13d8abce0ff9565ed223c5e4b9906160816ee8fa@94.62.146.145:36656,ff4a0e9cd3c5dbec947470005d578a816ce9a77a@5.189.166.45:43806,09263a4168de6a2aaf7fef86669ddfe4e2d004f6@142.132.209.229:36590,937db64cda8f79d1ef971ce1755dba26485ce085@65.108.89.238:26656,1d6a3c3d9ffc828b926f95592e15b1b59b5d8175@51.210.33.125:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.celestia-app/config/config.toml
SEEDS=""
sed -i -e "/seeds =/ s/= .*/= \"$SEEDS\"/"  $HOME/.celestia-app/config/config.toml
bpeers="f0c58d904dec824605ac36114db28f1bf84f6ea3@144.76.112.238:26656"
sed -i.bak -e "s/^bootstrap-peers *=.*/bootstrap-peers = \"$bpeers\"/" $HOME/.celestia-app/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="5000"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
\"$pruning_keep_recent\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \
\"$pruning_keep_every\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
\"$pruning_interval\"/" $HOME/.celestia-app/config/app.toml
sed -i.bak -e "s/^timeout-commit *=.*/timeout-commit = \"25s\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^skip-timeout-commit *=.*/skip-timeout-commit = false/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/.celestia-app/config/config.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external-address = \"\"/external-address = \"$external_address:26656\"/" $HOME/.celestia-app/config/config.toml


tee $HOME/celestia-appd.service > /dev/null <<EOF
[Unit]
Description=celestia-appd
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which celestia-appd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/celestia-appd.service /etc/systemd/system/

cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | \
    egrep -o ">mamaki.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - \
    -C ~/.celestia-app/data/

# start service
sudo systemctl daemon-reload
sudo systemctl enable celestia-appd
sudo systemctl restart celestia-appd

break
;;

"Check Log")

journalctl -u celestia-appd -f -o cat

break
;;


"Check balance")
celestia-appd q bank balances $(celestia-appd keys show $WALLETNAME -a --bech acc)
break
;;

"Create Validator")
celestia-appd tx staking create-validator \
  --amount 1000000utia \
  --from $WALLETNAME \
  --commission-max-change-rate "0.05" \
  --commission-max-rate "0.20" \
  --commission-rate "0.05" \
  --min-self-delegation "1" \
  --pubkey $(celestia-appd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $CHAIN_ID \
  --gas 300000 \
  -y
break
;;

"Request tokens in discord")
echo "========================================================================================================================"
echo "You can request from Mamaki Testnet Faucet on the #faucet channel on Celestia's Discord server with the following command: $request <CELESTIA-ADDRESS>"
echo "========================================================================================================================"

break
;;

"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done