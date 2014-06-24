echo "US/Eastern" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

sudo apt-get -y install ntp
sudo service ntp start
