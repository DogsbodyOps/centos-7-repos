#!/bin/bash

# Check release of OS, if not centos7 exit entire script with a success code and message
if [ -f /etc/redhat-release ]; 
  then
    version=$( cat /etc/redhat-release | grep -oP "[0-9]+" | head -1 )
      if [ $version -ne 7 ];
        then
          echo "This is not CentOS 7, exiting script."
          exit 0
        else
          echo "CentOS 7 detected, continuing with script."
      fi
fi

if [ -f /home/repos_updated.marker ];
  then
    echo "Marker File Exists, doing nothing"
    exit 0
fi

# Backup existing repo files for safety, you just never know when you'll need repo files that dont work anymore.
echo "Moving current repo files to .bak"
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak 2>/dev/null
mv /etc/yum.repos.d/CentOS-Vault.repo /etc/yum.repos.d/CentOS-Vault.repo.bak 2>/dev/null

# Remove redundant/unused repo files
echo "Removing redundant repo files"
rm -f /etc/yum.repos.d/CentOS-CR.repo
rm -f /etc/yum.repos.d/CentOS-Debuginfo.repo
rm -f /etc/yum.repos.d/CentOS-Media.repo
rm -f /etc/yum.repos.d/CentOS-Sources.repo
rm -f /etc/yum.repos.d/CentOS-fasttrack.repo
rm -f /etc/yum.repos.d/CentOS-x86_64-kernel.repo
rm -f /etc/yum.repos.d/epel.repo
rm -f /etc/yum.repos.d/epel-testing.repo

# This will be changed to a controlled repo when testing is complete.
echo "wget known good repo files to location"
wget https://raw.githubusercontent.com/DogsbodyOps/centos-7-repos/refs/heads/main/CentOS-Base.repo -P /etc/yum.repos.d/
wget https://raw.githubusercontent.com/DogsbodyOps/centos-7-repos/refs/heads/main/CentOS-Vault.repo -P /etc/yum.repos.d/


# Creates a marker file to let the script/playbook know it's been here before.
echo "Creating marker file if it doesnt exist."
cat > /home/repos_updated.marker << EOF
Last Updated $(date +"%Y-%m-%d")

Repos were updated to allow for patching.

CentOS-Base configured to disable all repos.
CentOS-Vault configured to enable all vault repos
This file serves as a marker to be used to prevent playbooks or scripts for doing the work every time it connects and runs.

Please use it.
Aaron Watson ~ Sept 2024
EOF
