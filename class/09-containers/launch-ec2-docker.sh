#!/bin/bash
# Launch the docker-build instance: Ubuntu with Docker, installed at first boot by
# user_data_docker.sh. The instance gets the role LabRole (LabInstanceProfile), so
# containers on it can read S3 without ~/.aws/credentials.
# Run in the terminal on your computer, from class/09-containers:
#   bash launch-ec2-docker.sh

set -euo pipefail

# Ubuntu Server 26.04 LTS in us-east-1, the same AMI as in class 07
AMI=ami-0b6d9d3d33ba97d99
USER_DATA="user_data_docker.sh"

# Reuse the security group from class 07 by name; create it if it does not exist
SG_NAME=launch-wizard-1
SG=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=$SG_NAME" \
  --query 'SecurityGroups[0].GroupId' --output text)
if [ "$SG" = "None" ]; then
  SG=$(aws ec2 create-security-group \
    --group-name "$SG_NAME" \
    --description "SSH from anywhere" \
    --query 'GroupId' --output text)
  aws ec2 authorize-security-group-ingress \
    --group-id "$SG" --protocol tcp --port 22 --cidr 0.0.0.0/0 > /dev/null
  echo "Created security group $SG_NAME"
fi

# --iam-instance-profile: the instance role LabRole gives credentials for S3 and SSM
# --metadata-options: IMDSv2 only, hop limit 2, so containers can reach the role's
#   credentials (a container is one extra network hop away from the instance)
# --block-device-mappings: 20 GB disk instead of 8 GB, room for images and layers
IID=$(aws ec2 run-instances \
  --image-id "$AMI" \
  --instance-type t3.micro \
  --key-name vockey \
  --security-group-ids "$SG" \
  --iam-instance-profile Name=LabInstanceProfile \
  --metadata-options "HttpTokens=required,HttpPutResponseHopLimit=2,HttpEndpoint=enabled" \
  --block-device-mappings 'DeviceName=/dev/sda1,Ebs={VolumeSize=20,VolumeType=gp3}' \
  --user-data "file://$USER_DATA" \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=docker-build}]' \
  --query 'Instances[0].InstanceId' --output text)
echo "Launched instance: $IID"

# Wait until it is running, then print its public IP
aws ec2 wait instance-running --instance-ids "$IID"
IP=$(aws ec2 describe-instances --instance-ids "$IID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo "Running, public IP address: $IP. Connect with:"
echo "  ssh -i ~/.ssh/labsuser.pem ubuntu@$IP"
echo "On the instance, wait for the Docker install to finish with:"
echo "  cloud-init status --wait"
echo "Terminate with:"
echo "  aws ec2 terminate-instances --instance-ids $IID"
