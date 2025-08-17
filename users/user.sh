#!/bin/bash

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
