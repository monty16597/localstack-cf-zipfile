#!/bin/bash

# Create S3
awslocal s3 mb s3://lambda-code-bucket --endpoint-url=http://localhost:4566 && echo 'Bucket lambda-code-bucke created' || echo 'can not create bucket'

# Zip code
zip -r lambda.zip code.py && echo 'zip done' || echo 'zip error'

# Upload zip file
awslocal s3api put-object --bucket lambda-code-bucket  --key lambda.zip --body lambda.zip --endpoint-url=http://localhost:4566 && echo 'zip uploaded' || echo 'zip uploading error'

# retrive upload object
echo 'list of the objects' && awslocal s3api list-objects --bucket lambda-code-bucket || echo 'error while listing objects'

# Deploy stack
echo 'executing template -------------------'
awslocal cloudformation deploy --template-file=cf_template.yml --region=us-east-1 --stack-name=my-stack --endpoint-url=http://localhost:4566 && echo 'Created' || echo 'error'

# List lambda function created from the stack
awslocal lambda list-functions > lambda.json || echo 'error while listing functions'

# Invoking function
echo 'invoking function ----------------------'
awslocal lambda invoke --function-name $(cat lambda.json | jq -r .Functions[0].FunctionName)  output.log || echo 'error while invoking'