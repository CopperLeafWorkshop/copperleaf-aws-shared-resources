#!/bin/bash
#
# deploy.sh 
#

###
# Manage KeyPair
#

# Check if the private key exists now, if not:
if [ ! -f ./keys/shared_ec2.pem ]; then
	# Create AWS Key-Pair
	aws ec2 create-key-pair --key-name shared-ec2 --query 'KeyMaterial' --output text > ./keys/shared_ec2.pem
	chmod 400 ./keys/shared_ec2.pem
fi

if [ ! -f ./keys/shared_ec2.pub ]; then
	# Create the public key for terraform
	ssh-keygen -y -f ./keys/shared_ec2.pem  > ./keys/shared_ec2.pub
fi

###
# Run Terraform
#

terraform plan 
read -p "Apply? (y/n) : " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    terraform apply 
fi
terraform graph | dot -Tpng > graph-shared.png
