#!/bin/bash
# EC2 user data: runs once, as root, the first time the instance boots.
# Installs Docker Engine from Docker's apt repository (Ubuntu 26.04, as in
# https://docs.docker.com/engine/install/ubuntu/), lets the ubuntu user run docker,
# and clones the DS2022 repository into /home/ubuntu/DS2022.
# Used by launch-ec2-docker.sh (--user-data file://user_data_docker.sh)

set -euo pipefail

# 1. Tools for adding the Docker repository, and git
apt-get update -y
apt-get install -y ca-certificates curl git

# 2. Docker's signing key and apt repository
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# 3. Docker Engine, CLI, and the buildx plugin; the docker service starts on its own
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin

# 4. Let the ubuntu user run docker without sudo (the docker group is equivalent to root)
usermod -aG docker ubuntu

# 5. Clone the course repository and give it to the ubuntu user
git clone https://github.com/ksiller/DS2022.git /home/ubuntu/DS2022
chown -R ubuntu:ubuntu /home/ubuntu/DS2022
