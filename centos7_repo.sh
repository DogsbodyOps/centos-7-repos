#!/bin/bash

if ! [ -f /home/repos_updated.marker ];
  then
    echo "Moving current repo files to .bak"
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    mv /etc/yum.repos.d/CentOS-Vault.repo /etc/yum.repos.d/CentOS-Vault.repo.bak
  else
    echo "Marker File Exists, doing nothing"
fi

# This will be changed to a controlled repo when testing is complete.
if ! [ -f /home/repos_updated.marker ];
  then
    echo "wget known good repo files to location"
    wget https://git.thedc.space/thedcspace/centos-7-repos/raw/branch/main/CentOS-Base.repo -P /etc/yum.repos.d/
    wget https://git.thedc.space/thedcspace/centos-7-repos/raw/branch/main/CentOS-Vault.repo -P /etc/yum.repos.d/
  else
    echo "Marker File Exists, doing nothing"
fi

# Creates a marker file to let the script/playbook know it's been here before.
echo "Creating marker file if it doesnt exist."
if ! [ -f /home/repos_updated.marker ];
  then
    cat > /home/repos_updated.marker << EOF
    Repos were updated to allow for patching.

    CentOS-Base configured to disable all repos.
    CentOS-Vault configured to enable all vault repos

    This file serves as a marker to be used to prevent playbooks or scripts for doing the work every time it connects and runs.

    Please use it.

    Aaron Watson ~ Sept 2024
EOF
  else
    echo "Marker File Exists, doing nothing"
fi