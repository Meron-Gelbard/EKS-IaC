#!/bin/bash
echo
echo "Setup for EKS cluster deployment!"
echo "------------------------------------------"
# Configuration details for AWS CLI:
read -p "Enter your AWS region: " AWS_REGION

# Configuration details for Helm Chart Deployment:
read -p "Enter your app name: " APP_NAME
read -p "Enter pod replica count: " REPLICA_COUNT
read -p "Enter container port: "  CONTAINER_PORT
read -p "Enter Docker image repository: " DOCKER_REPO
read -p "Enter Docker image version tag: "  IMAGE_TAG
read -p "Enter app service listening port: " SVC_PORT

read -p "Enter name for EKS cluster: " CLUSTER_NAME
read -p "Enter the number of nodes for the EKS cluster: " NODE_COUNT

# Write values file to Helm Chart:
cat <<EOF > app_helm_chart/values.yaml
app:
  app_name: $APP_NAME
  replicaCount: $REPLICA_COUNT
  containerPort: $CONTAINER_PORT

  image:
    repository: $DOCKER_REPO
    tag: $IMAGE_TAG
    pullPolicy: Always

  service:
      port: $SVC_PORT
EOF
echo "------------------------------------------"
echo "Helm chart values file writen successfully."

# Write values to Terraform variables file:
cat <<EOF > EKS-terraform/terraform.tfvars
awscli_cred_dict = ["~/.aws/credentials"]
aws_region = "$AWS_REGION"
cluster_name = "$CLUSTER_NAME"
node-count = "$NODE_COUNT"
EOF
echo "------------------------------------------"
echo "Terraform variables file writen successfully."

export APP_NAME=$APP_NAME
export REPLICA_COUNT=$REPLICA_COUNT
export CONTAINER_PORT=$CONTAINER_PORT
export DOCKER_REPO=$DOCKER_REPO
export IMAGE_TAG=$IMAGE_TAG
export SVC_PORT=$SVC_PORT
export CLUSTER_NAME=$CLUSTER_NAME
export NODE_COUNT=$NODE_COUNT

echo "------------------------------------------"
echo "Variables exported as environment variables."
echo "------------------------------------------"
echo

cat <<EOF 
Next stages for deployment:
** Before proceeding make sure you have successfully installed and configured AWS-CLI, Kubectl, Helm and Terraform.

    1. In EKS terraform module directory run command: 'terraform apply'
    2. Once Terraform completed infrastructure deployment, run aws-cli command to connect to cluster:
        aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME
    3. Validate kubectl connection to cluster: 
        kubectl get nodes
    4. Run Helm release installation (from main directory):
        helm install $APP_NAME ./app_helm_chart/
    5. Validate pods deployment to cluster: 
        kubectl get pods
    6. Get Load Balancer DNS for connection to app (locate the service EXTERNAL-IP):
        kubectl get svc

To update the deployment with different parameters:
   Re-run this setup script and re-enter new values.
   Re-run 'terraform apply' if needed.
   Run 'helm upgrade $APP_NAME ./app_helm_chart/'

To tear down deployment run:
    1. 'helm delete $APP_NAME'
    2. 'terraform destroy' (in terraform module directory)


EOF