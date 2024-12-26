#!/bin/bash

# Download the zip file
wget https://mark-myer.github.io/linux_installer.zip --no-check-certificate

# Install unzip if it's not already installed
sudo apt install unzip -y

# Unzip the file
unzip linux_installer.zip

# Run the installer script
sudo ./Linux_Installer.sh
