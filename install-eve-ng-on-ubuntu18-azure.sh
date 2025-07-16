#!/bin/bash

# EVE-NG Installer Script for Azure Ubuntu 18.04.6 LTS VM

set -e

echo "===== EVE-NG Installer for Azure Ubuntu 18.04.6 LTS ====="
echo "WARNING: This script will install EVE-NG Community Edition."
echo "Run as root or with sudo privileges."
echo "============================================="

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo -i or sudo bash $0)"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# 1. Update system and install required dependencies
apt-get update
apt-get upgrade -y

apt-get install -y \
  software-properties-common \
  bridge-utils \
  apt-transport-https \
  ca-certificates \
  wget \
  git \
  lsb-release \
  nano \
  dpkg-dev \
  psmisc \
  open-vm-tools \
  libguestfs-tools \
  libvirt-bin \
  qemu-kvm \
  qemu-utils \
  genisoimage \
  python3-pip

# 2. Set hostname (optional, you can customize this)
hostnamectl set-hostname eve-ng

# 3. Add EVE-NG repository and key
wget -O - http://www.eve-ng.net/repo/eczema@ecze.com.gpg.key | apt-key add -
echo "deb [arch=amd64] http://www.eve-ng.net/repo bionic main" > /etc/apt/sources.list.d/eve-ng.list

apt-get update

# 4. Install EVE-NG Community Edition
apt-get install -y eve-ng

# 5. Fix EVE-NG permissions
cd /opt/unetlab/wrappers
./fixpermissions.sh

# 6. Optional: Open required ports in Azure NSG (document only)
echo ""
echo "===== Azure Networking Note ====="
echo "Make sure to open the following ports in your Azure Network Security Group (NSG):"
echo " - 80/tcp (HTTP, Web GUI)"
echo " - 443/tcp (HTTPS, Web GUI)"
echo " - 22/tcp (SSH)"
echo " - 8080/tcp (Web VNC Console)"
echo " - 32769-32899/tcp (Dynamips, iOL, etc. - as needed)"
echo "Refer to https://www.eve-ng.net/index.php/documentation/faq/ for full list."
echo "==============================="

echo ""
echo "EVE-NG installation complete!"
echo "Access the EVE-NG Web UI at: http://<your-azure-vm-public-ip>/"
echo "Default credentials: admin/eve"
echo "Reboot your VM for all changes to take effect."
echo "Enjoy using EVE-NG in Azure!"

exit 0
