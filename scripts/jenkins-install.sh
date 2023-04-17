#!/bin/bash -x
exec > >(tee /var/log/userdata.log) 2>&1

# docker install
sudo apt-get -y update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt-get -y update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
newgrp docker

# ansible install
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get -y install ansible
sudo apt-get -y update
sudo apt-get install -y python-docker
sudo apt-get install -y python3-docker

# volume setup
# The sudo vgchange -ay command will activate all inactive volume groups on a Linux system.
sudo vgchange -ay
# Set disk device name
DEVICE_NAME=${DEVICE}
DIR="/var/lib/jenkins"
USERNAME="ubuntu"
JENKINS_USERNAME="jenkins"
DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`


if [ "`echo -n $DEVICE_FS`" == "" ] ; then 
  # wait for the device to be attached
  sleep 30
fi

# Create physical volume
sudo pvcreate $DEVICE_NAME
echo "Physical volume created"

# Create volume group
sudo vgcreate data $DEVICE_NAME
echo "Volume group created"

# Create logical volume
sudo lvcreate -n volume1 -L 10G data
echo "Logical volume created"


# Check if disk is already mounted
if grep -qs "$DEVICE_NAME" /proc/mounts; then
   echo "Disk is already mounted"
   exit 1

else
   # Mount disk
   sudo mkfs.ext4 /dev/data/volume1
   sudo mkdir  -p $DIR
   sudo mount /dev/data/volume1 $DIR
   echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
fi

# install dependencies
sudo apt-get -y update
sudo apt-get install -y openjdk-11-jdk awscli openssl whois

curl -fsSL ${JENKINS_URL}/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get -y update
sudo apt-get -y install jenkins

# Check if the script is being run as root
if [ $(id -u) -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Check if the user exists
if ! id $USERNAME > /dev/null 2>&1; then
    echo "User $USERNAME does not exist"
    exit 1
else
   # Add the user to the sudo group
   usermod -aG sudo $USERNAME
   # Add the user to the sudoers file
   echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

# Check if the user exists
if ! id $JENKINS_USERNAME > /dev/null 2>&1; then
    echo "User $JENKINS_USERNAME does not exist"
    exit 1
else
   # Add the user to the sudo group
   usermod -aG sudo $JENKINS_USERNAME
   # Add the user to the sudoers file
   echo "$JENKINS_USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

# echo Jenkins current password
JENKINS_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

# AWS Credentials
AWS_REGION=${AWS_REGION}
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

# Store the password as a secret in AWS Secrets Manager
aws secretsmanager create-secret --name ${JENKINS_ADMIN} --secret-string "$JENKINS_PASSWORD" --description "Jenkins secrets to login UI." --region $AWS_REGION