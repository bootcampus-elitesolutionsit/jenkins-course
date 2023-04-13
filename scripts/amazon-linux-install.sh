#!/bin/bash -x
exec > >(tee /var/log/userdata.log) 2>&1

# Install ansible
sudo yum -y update
sudo yum install -y python-docker
sudo yum install -y python3-docker
sudo yum install -y git

# docker install
sudo amazon-linux-extras install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker

# ansible install
sudo amazon-linux-extras install -y ansible2

# volume setup

# The sudo vgchange -ay command will activate all inactive volume groups on a Linux system.
sudo vgchange -ay
# Set disk device name
DEVICE_NAME=${DEVICE}
DIR="/var/lib/jenkins"
USERNAME="ec2-user"
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
   sudo mkdir -p $DIR
   sudo mount /dev/data/volume1 $DIR
   echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
fi

# install dependencies
sudo yum -y update
sudo yum install -y awscli openssl whois
sudo amazon-linux-extras install -y java-openjdk11 -y

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum -y upgrade
sudo yum install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

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
   usermod -aG wheel $USERNAME
   # Add the user to the sudoers file
   echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

# Check if the user exists
if ! id $USERNAME > /dev/null 2>&1; then
    echo "User $USERNAME does not exist"
    exit 1
else
   # Add the user to the sudo group
   usermod -aG wheel $USERNAME
   # Add the user to the sudoers file
   echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

# Check if the user exists
if ! id $JENKINS_USERNAME > /dev/null 2>&1; then
    echo "User $JENKINS_USERNAME does not exist"
    exit 1
else
   # Add the user to the sudo group
   usermod -aG wheel $JENKINS_USERNAME
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

