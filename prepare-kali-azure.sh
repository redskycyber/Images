#!/bin/bash
set -e

# 1️⃣ Update system
sudo apt update
sudo apt -y full-upgrade

# Install standard Kali tools
sudo apt install -y \
    kali-linux-default \
    kali-linux-top10 \
    nmap metasploit-framework sqlmap gobuster

# Install and configure RDP (xrdp)
sudo apt install -y xrdp xfce4 xfce4-goodies

# Configure XFCE for xrdp sessions (new users will get this via cloud-init)
echo "startxfce4" | sudo tee /etc/skel/.xsession

# Enable and start xrdp service
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Optional: open firewall in the VM (Azure NSG rules are separate)
# xrdp default port is 3389, ensure NSG allows inbound TCP 3389

# Clean up
sudo apt autoremove -y
sudo apt clean

# Clear shell history (cosmetic)
history -c
rm -f ~/.bash_history
sudo rm -f /root/.bash_history
export HISTFILE=/dev/null

# Deprovision VM for Azure
sudo waagent -deprovision+user -force

# Shutdown
sudo shutdown now
