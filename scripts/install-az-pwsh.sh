#!/usr/bin/env bash

set -e
set -v

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y apt-transport-https lsb-release gnupg curl

#1. Add Microsoft's GPG Key has a trusted source of apt packages.
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.asc.gpg
CLI_REPO=$(lsb_release -cs)

#2. Add Azure CLI repository
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ ${CLI_REPO} main" \
    > /etc/apt/sources.list.d/azure-cli.list

#3. Add Powershell repository
echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-${CLI_REPO}-prod ${CLI_REPO} main" \
    > /etc/apt/sources.list.d/microsoft.list

#5. Install
apt-get update \
    && apt-get install -y \
        azure-cli \
        powershell