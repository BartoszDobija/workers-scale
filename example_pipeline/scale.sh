#! /bin/sh

set -e

echo "\$AWS_REGION: $AWS_REGION"
echo "\$AWS_AZ: $AWS_AZ"
echo "\$BACKEND_BUCKET: $BACKEND_BUCKET"
echo "\$BACKEND_KEY: $BACKEND_KEY"
echo "\$INSTANCE_AMI_ID: $INSTANCE_AMI_ID"
echo "\$INSTANCE_TYPE: $INSTANCE_TYPE"
echo "\$INSTANCE_VOLUME_SIZE: $INSTANCE_VOLUME_SIZE"
echo "\$INSTANCE_VOLUME_THROUGHPUT: $INSTANCE_VOLUME_THROUGHPUT"
echo "\$INSTANCE_VOLUME_IOPS: $INSTANCE_VOLUME_IOPS"
echo "\$RUNNERS: $RUNNERS"
echo "\$RUNNER_SLOTS: $RUNNER_SLOTS"
echo "\$RUNNER_TAG: $RUNNER_TAG"

export TF_VAR_AWS_REGION=$AWS_REGION
export TF_VAR_AWS_AZ=$AWS_AZ
export TF_VAR_RUNNERS=$RUNNERS
export TF_VAR_INSTANCE_AMI_ID=$INSTANCE_AMI_ID
export TF_VAR_INSTANCE_TYPE=$INSTANCE_TYPE
export TF_VAR_INSTANCE_VOLUME_SIZE=$INSTANCE_VOLUME_SIZE
export TF_VAR_INSTANCE_VOLUME_THROUGHPUT=$INSTANCE_VOLUME_THROUGHPUT
export TF_VAR_INSTANCE_VOLUME_IOPS=$INSTANCE_VOLUME_IOPS
export TF_VAR_INSTANCE_PUBLIC_KEY=$INSTANCE_PUBLIC_KEY
export TF_VAR_BACKEND_KEY=$BACKEND_KEY
export TF_VAR_BACKEND_BUCKET=$BACKEND_BUCKET
echo "$INSTANCE_PRIVATE_KEY" > key.pem

cp install.tmpl.sh install.sh
sed -i "s/STANDALONE_TOKEN/$STANDALONE_TOKEN/g" install.sh
sed -i "s/STANDALONE_HOST/$STANDALONE_HOST/g" install.sh
sed -i "s/RUNNER_TAG/$RUNNER_TAG/g" install.sh
sed -i "s/RUNNER_SLOTS/$RUNNER_SLOTS/g" install.sh

terraform init -migrate-state -upgrade -input=false -backend-config="bucket=$BACKEND_BUCKET" -backend-config="key=$BACKEND_KEY" -backend-config="region=$AWS_REGION"
terraform apply -auto-approve -input=false

rm key.pem
