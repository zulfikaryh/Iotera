#!/bin/sh

ASK_TO_REBOOT=0

# update OS
echo '>>> Update OS Image'
sudo apt-get update
sudo apt-get -y upgrade

# install nodejs via nvm
echo '>>> Install NodeJs'
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts
sudo cp -R $NVM_DIR/versions/node/$(nvm version)/* /usr/local/

# install git
echo '>>> Install Git'
sudo apt-get -y install git

# install wiring pi
cd /tmp
wget https://project-downloads.drogon.net/wiringpi-latest.deb
sudo dpkg -i wiringpi-latest.deb
cd ~

# install and configure PiPowerMeter
if [ ! -d "app" ]; then
    echo '>>> Install PiPowerMeter'
    git clone https://github.com/crjens/PiPowerMeter.git app
    cd app
    npm install
    ASK_TO_REBOOT=1
else
    echo '>>> PiPowerMeter already installed'
fi
 
echo '>>> PiPowerMeter is installed'
if [ $ASK_TO_REBOOT -ne 0 ]; then
    echo '>>> Restarting...'
    sudo reboot
fi

exit 0
