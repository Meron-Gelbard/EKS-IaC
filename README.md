# AWS Elastic Kubernetes Service - Infrastructure as Code using Terraform

## Overview

This project provides a Terraform module for deploying a comprehensive AWS infrastructure, including a Virtual Private Cloud (VPC) with two private and two public subnets, NAT and internet gateways, and all necessary routing tables. Additionally, the module facilitates the deployment of an Amazon Elastic Kubernetes Service (EKS) cluster within this VPC. An example Helm chart is also included for deploying a web application into the EKS cluster.

## Prerequisites

Before you begin, ensure you have the following prerequisites installed and configured on your local machine:

1. **AWS CLI:** Install and configure the `AWS Command Line Interface` with appropriate credentials. [Install AWS CLI](https://aws.amazon.com/cli/)

   ```bash
   # Example installation on Linux
   sudo apt-get install awscli
   ```

2. **Terraform:** Install `Terraform` by following instructions on [Terraform's official website](https://www.terraform.io/downloads.html).

   ```bash
   # Example installation on Linux
   wget https://releases.hashicorp.com/terraform/0.15.4/terraform_0.15.4_linux_amd64.zip
   unzip terraform_0.15.4_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

3. **kubectl:** Install `kubectl` to interact with the Kubernetes cluster.

   ```bash
   # Example installation on Linux
   sudo curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && sudo chmod +x /usr/local/bin/kubectl
   ```

4. **Helm:** Install `Helm` by following the instructions on [Helm's official website](https://helm.sh/docs/intro/install/).

   ```bash
   # Example installation on Linux
   curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
   ```

## Project Setup

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/Meron-Gelbard/EKS-IaC.git
   ```

2. **Update Dynamic Values:**

   - Navigate to the project directory and run the setup script.
   - This script dynamically configures values for the Terraform module and The Helm chart.
   - The script will prompt to enter values such as AWS region, EKS cluster name, number of nodes, number of pods, Docker image and ports.
   - Script will also export these variables ans environment variable for further use.

   *(make sure to use "source")*
   
   ```bash
   source setup.sh
   ```

3. **Deploy Infrastructure with Terraform:**

   - Navigate to the Terraform directory.

   ```bash
   cd EKS-terraform
   ```

   - Initialize Terraform.

   ```bash
   terraform init
   ```

   - Validate the deployment plan.
    ```bash
   terraform plan
   ```
   
   - Apply the Terraform configuration to deploy the infrastructure. 
   *(This might take sevral minutes...)*

   ```bash
   terraform apply
   ```

4. **Configure kubectl for EKS:**

   - Once Terraform succefully deployed infrastructure, connect *kubectl* to the new EKS cluster.

   ```bash
   aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME
   ```

   - Validate Connection to EKS Cluster by ensuring cluster nodes are retrieved successfully.

   ```bash
   kubectl get nodes
   ```

5. **Deploy Web Application with Helm:**

   - Install the *Helm chart* release with the set values from environment variable.
    *(from root repo directory)*

   ```bash
   helm install $APP_NAME ./app_helm_chart/
   ```

6. **Validate Deployment:**

   - Check Helm releases.

   ```bash
   helm ls
   ```

   - Check deployed pods.

   ```bash
   kubectl get pods
   ```

   - Get the new Load Balancer service DNS.
    *The app will be available at the domain writen under the your-app-service `EXTERNAL-IP` at the configured port*

   ```bash
   kubectl get svc
   ```

   **The web application is now accessible via DNS of the AWS Load Balancer created by Helm deployment and the EKS cluster.**


## Update Deployment

To update the deployment with different parameters:

   - Re-run setup script and re-enter new values.
   - Re-run `terraform apply` if needed.
   - Run `helm upgrade $APP_NAME ./app_helm_chart/` if needed.


## Clean Up Deployment

To remove all the resources created by this project:

1. **Delete the Helm release installation**

```bash
helm delete $APP_NAME
```

2. **Destroy Terraform infrastructure**

```bash
terraform destroy
```

**Note:** *Destroying resources will permanently delete them!*
