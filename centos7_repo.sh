#!/bin/bash

# Check release of OS, if not centos7 exit entire script witrh a success code and message
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

# Backup exsiting repo files for safety, you just never know when you'll need repo files that dont work anymore.
echo "Moving current repo files to .bak"
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
mv /etc/yum.repos.d/CentOS-Vault.repo /etc/yum.repos.d/CentOS-Vault.repo.bak


# This will be changed to a controlled repo when testing is complete.
echo "wget known good repo files to location"
wget https://github.com/DogsbodyOps/centos-7-repos/raw/branch/main/CentOS-Base.repo -P /etc/yum.repos.d/
wget https://github.com/DogsbodyOps/centos-7-repos/raw/branch/main/CentOS-Vault.repo -P /etc/yum.repos.d/


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