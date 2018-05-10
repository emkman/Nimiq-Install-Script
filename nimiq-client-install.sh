#!/bin/bash
################################################################################
# Author:  Bhlynd
# Program: Install Nimiq on Ubuntu
# Flavor: Porky Pool (https://www.porkypool.com)
################################################################################
output() {
  printf "\E[0;33;40m"
  echo $1
  printf "\E[0m"
}

displayErr() {
  echo
  echo $1;
  echo
  exit 1;
}


output " "
output " "
output "Please double check before hitting enter! You only have one shot at these!"
output " "
POOL="us-east.porkypool.com:8444"
THREADS=$(getconf _NPROCESSORS_ONLN)
WALLET="NQ03 7EHY 0UFJ 6S6Q 2XAG YHN6 3J22 JM6A 926G"
EXTRADATA=$(uname -a | awk  '{print $2}')
STATISTICS=15



output " "
output "Downloading Nimiq core."
output " "

git clone https://github.com/ryan-rowland/core.git

output " "
output "Building Nimiq core client."
output " "

cd core
npm install
npm run prepare

output " "
output "Building launch scripts."
output " "

cd ..
echo '#!/bin/bash
SCRIPT_PATH=$(dirname "$0")/core
$SCRIPT_PATH/clients/nodejs/nimiq "$@"' > miner
chmod u+x miner

echo '#!/bin/bash
UV_THREADPOOL_SIZE='"${THREADS}"' ./miner --dumb --pool='"${POOL}"' --miner='"${THREADS}"' --wallet-address="'"${WALLET}"'" --extra-data="'"${EXTRADATA}"'" --statistics='"${STATISTICS}"'' > start
chmod u+x start

output " "
output "Downloading consensus."
output " "

if [ ! -d "./main-full-consensus" ]; then
  wget https://github.com/ryan-rowland/Nimiq-Install-Script/raw/master/main-full-consensus.tar.gz
  tar -xvf main-full-consensus.tar.gz
  rm main-full-consensus.tar.gz
fi

output "Congratulations! If everything went well you can now start mining."
output " "
output "To start the miner type ./start"
output " "
output "If you need to change any settings, you can do so by editing the start file."
