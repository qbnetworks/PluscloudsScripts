#!/bin/bash

# check if root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# make a backup of old executables
if [ ! -d "/var/backups/woodpecker" ]; then
	mkdir -p /var/backups/woodpecker
fi
cp /usr/local/bin/{woodpecker-server,woodpecker-cli,woodpecker-agent} /var/backups/woodpecker

# download executables
mkdir /tmp/woodpecker-temp && cd /tmp/woodpecker-temp
curl -s https://api.github.com/repos/woodpecker-ci/woodpecker/releases/latest | grep "woodpecker-server_linux_amd64.tar.gz" | cut -d : -f 2,3 | tr -d \" | wget -qi -
curl -s https://api.github.com/repos/woodpecker-ci/woodpecker/releases/latest | grep "woodpecker-agent_linux_amd64.tar.gz" | cut -d : -f 2,3 | tr -d \" | wget -qi -
curl -s https://api.github.com/repos/woodpecker-ci/woodpecker/releases/latest | grep "woodpecker-cli_linux_amd64.tar.gz" | cut -d : -f 2,3 | tr -d \" | wget -qi -

# install executables
for f in /tmp/woodpecker-temp/*.tar.gz; do
	tar -xf "$f" -C /usr/local/bin
done


# restart services
systemctl restart woodpecker woodpecker-agent


# cleanup
rm -r /tmp/woodpecker-temp
