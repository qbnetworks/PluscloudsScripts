#!/bin/bash
#
# Copyright (C) 2025 QB Networks
#
# Copyright (C) 2025 Masscollabs Services
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
