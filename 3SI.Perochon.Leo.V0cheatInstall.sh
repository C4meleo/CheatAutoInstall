#!/bin/bash

# Install requirements
apt install sudo git tree vim rsync mlocate -y

wget https://github.com/cheat/cheat/releases/download/4.2.3/cheat-linux-amd64.gz

gunzip cheat-linux-amd64.gz

chmod +x cheat-linux-amd64

mv -v cheat-linux-amd64 /usr/local/bin/cheat

mkdir -p ~/.config/cheat && cheat --init > ~/.config/cheat/conf.yml

git clone https://github.com/cheat/cheatsheets

mkdir -vp ~/.config/cheat/cheatsheets/community
mkdir -vp ~/.config/cheat/cheatsheets/personal

mv --backup=numbered ~/cheatsheets/* ~/.config/cheat/cheatsheets/community

mkdir -p /opt/COMMUN/cheat/
mv ~/.config/cheat/* /opt/COMMUN/cheat/
rm -rf ~/.config/cheat

# Change cheat conf directory in config file
sed -i 's;/root/.config;/opt/COMMUN;' /opt/COMMUN/cheat/conf.yml

groupadd commun

# Setup symbolic link in users .config/
ln -s /opt/COMMUN/cheat ~/.config/cheat

for user_home in /home/*;
do
	mkdir -vp "$user_home/.config"
	ln -s /opt/COMMUN/cheat "$user_home/.config/cheat"
	IFS='/'
	read -ra ARR <<< $user_home
	usermod -g commun ${ARR[2]} # When creating personal cheat editable by other
done

mkdir -vp /etc/skel/.config
ln -s /opt/COMMUN/cheat /etc/skel/.config/cheat

# Create esgi user
useradd -m -g commun -s /bin/bash esgi
echo "esgi:Pa55w.rd" | chpasswd

# Set right permission
chown :commun /opt/COMMUN/cheat/cheatsheets/personal
chmod g+rw /opt/COMMUN/cheat/cheatsheets/personal

echo 'umask 007 -R /opt/COMMUN/cheat/cheatsheets/personal' > /etc/bash.bashrc


