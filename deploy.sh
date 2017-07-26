#!/bin/bash
#
# deploy.sh <rds_db_admin_password>
#

###
# Manage KeyPair
#

# Check if the private key exists now, if not:
if [ ! -f ./keys/informed-parents-uswest2.pem ]; then
	# Create AWS Key-Pair
	aws ec2 create-key-pair --key-name informed-parents-uswest2 --query 'KeyMaterial' --output text > ./keys/informed-parents-uswest2.pem
	chmod 400 ./keys/informed-parents-uswest2.pem
fi

if [ ! -f ./keys/informed-parents-uswest2.pub ]; then
	# Create the public key for terraform
	ssh-keygen -y -f ./keys/informed-parents-uswest2.pem  > ./keys/informed-parents-uswest2.pub
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
