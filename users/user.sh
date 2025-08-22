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

# Prompt for username
read -p "Enter username: " username

# Check if user exists
if getent passwd "$username" > /dev/null; then
    # Extract and parse GECOS field
    IFS=',' read -r name room work home other <<< "$(getent passwd "$username" | cut -d ':' -f 5)"
    
    # Display results
    echo "Full Name:     $name"
    echo "Room Number:   $room"
    echo "Work Phone:    $work"
    echo "Home Phone:    $home"
    echo "Other:         $other"
else
    echo "User '$username' not found."
fi
