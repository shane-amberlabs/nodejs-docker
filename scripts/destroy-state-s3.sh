#!/usr/bin/env bash

set -e
set -v

S3_NAME=jenkins-tfstate-s3
DYNAMODB_NAME=jenkins-tfstate-dynamodb
REGION=us-east-1

aws s3api delete-bucket --bucket $S3_NAME --region $REGION

aws dynamodb delete-table --table-name $DYNAMODB_NAME