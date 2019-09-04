#!/bin/bash

# Bucket Creation
aws s3api create-bucket --bucket kops-manzoni-bucket --region us-east-2 --create-bucket-configuration LocationConstraint=us-east-2

# Versioning Bucket
aws s3api put-bucket-versioning --bucket kops-manzoni-bucket  --versioning-configuration Status=Enabled

# Setting the default encryption
aws s3api put-bucket-encryption --bucket kops-manzoni-bucket --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'


