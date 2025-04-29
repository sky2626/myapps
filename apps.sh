#!/bin/bash

set -e

# Ensure Zenity is installed
sudo apt install -y zenity

# Start dialog
zenity --info --width=300 --title="Ubuntu App Installer" --text="Click OK to install your essential applications."

# Progress bar
(
echo "5" ; echo "# Updating system..." ; sleep 1
sudo apt update && sudo apt upgrade -y

echo "10" ; echo "# Installing snapd..." ; sleep 1
sudo apt install -y snapd
sudo systemctl enable --now snapd
sudo ln -s /var/lib/snapd/snap /snap 2>/dev/null || true

echo "20" ; echo "# Installing Snap apps..." ; sleep 1
declare -A snap_apps=(
    [code]="--classic"
    [postman]=""
    [spotify]=""
    [slack]=""
    [chromium]=""
    [opera]=""
    [discord]=""
    [brave]=""
)
for app in "${!snap_apps[@]}"; do
    sudo snap install "$app" ${snap_apps[$app]}
done

echo "40" ; echo "# Installing Google Chrome..." ; sleep 1
wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y /tmp/google-chrome.deb && rm /tmp/google-chrome.deb

echo "50" ; echo "# Installing balenaEtcher..." ; sleep 1
wget -q -O /tmp/etcher.deb https://github.com/balena-io/etcher/releases/download/v1.18.11/balena-etcher-electron_1.18.11_amd64.deb
sudo apt install -y /tmp/etcher.deb && rm /tmp/etcher.deb

echo "60" ; echo "# Installing AnyDesk..." ; sleep 1
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk.list
sudo apt update && sudo apt install -y anydesk

echo "70" ; echo "# Installing Docker Desktop..." ; sleep 1
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://desktop.docker.com/linux/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://desktop.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
| sudo tee /etc/apt/sources.list.d/docker-desktop.list > /dev/null
sudo apt update && sudo apt install -y docker-desktop

echo "85" ; echo "# Installing Docker Compose..." ; sleep 1
sudo curl -L "https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "95" ; echo "# Cleaning up Zenity..." ; sleep 1
sudo apt remove -y zenity

echo "100" ; echo "# Installation complete!"
) | zenity --progress \
  --title="Installing Applications" \
  --width=500 \
  --height=100 \
  --percentage=0 \
  --auto-close

# Final message
zenity --info --width=300 --title="Installation Complete" --text="✅ All applications were installed successfully!"

