#!/bin/bash
#
# deploy.sh <rds_db_admin_password>
#

###
# Run Terraform
#

terraform plan 
read -p "Apply? (y/n) : " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    terraform apply 
fi
