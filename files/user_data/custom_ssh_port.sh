#!/bin/bash
set -eux
sudo su
yum update -y || apt update -y
echo "Port 922" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart sshd
