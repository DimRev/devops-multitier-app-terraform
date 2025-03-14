# Scalable Multi-Tier Web Application on AWS

This repository deploys a scalable, secure, and highly available multi-tier web application on AWS using Terraform. The solution leverages modular Terraform code, remote state management, and advanced AWS services.

## Architecture Overview

The following diagram illustrates the core architecture:

![Architecture Diagram](assets/graph1.png)

### Key Points

- **Networking**: A dedicated VPC with public and private subnets. Public subnets connect to the Internet Gateway while private subnets use a NAT Gateway.
- **Compute**: The ALB distributes incoming traffic to an Auto Scaling Group of EC2 instances running Nginx.
- **Database**: A secure, Multi-AZ RDS MySQL instance accessible only from the private subnets.
- **Security**: Configured through IAM roles, security groups, and remote state management using S3 and DynamoDB.
- **Bastion Host**: A dedicated bastion (jump box) is deployed in a public subnet. **This host is used for debugging and troubleshooting** by allowing you to securely SSH into private EC2 instances without exposing them directly to the internet.

## Module Structure

The project is organized into reusable Terraform modules:

![Module Structure](assets/graph2.png)

- **VPC Module**:
  - Manages the VPC, subnets, gateways, and routing.
- **ALB Module**:
  - Sets up the Application Load Balancer with conditional HTTP/HTTPS listeners.
- **ASG Module**:
  - Deploys EC2 instances using launch templates with user data for bootstrapping Nginx and auto scaling.
- **RDS Module**:
  - Deploys a Multi-AZ RDS MySQL instance.
- **S3 Module**:
  - Creates (or references) an S3 bucket for state storage and artifacts.
- **Security Module**:
  - Configures IAM roles, policies, and instance profiles.
- **Bastion Module**:
  - Provides a jump box in a public subnet that is used for debugging purposes and for securely accessing private instances.

## Getting Started

### Prerequisites

- **Terraform**: [Download & install](https://www.terraform.io/downloads)
- **AWS CLI**: [Setup & configure](https://aws.amazon.com/cli/)
- **AWS Account**:
  - Ensure your account has the required permissions.
- **Backend Setup**:
  - Create an S3 bucket and DynamoDB table for Terraform state management.
- **SSH Public Key**:
  - Your local public key file (typically located at `~/.ssh/id_rsa.pub`) must be available. This key is used to create an AWS key pair and allows you to SSH into your instances (via the bastion host).
- **Assets Bucket**:
  - Create an S3 bucket to store the Terraform assets, the bucket will store the HTML files that get served by the ALB.
  - The bucket is defined under the variable `s3_bucket_name` in the `variables.tf` file.
  - The bucket must be in the same region as the VPC.
  - The bucket will store the logs for the ALB and the ASG.

## Deployment Steps

1. **Initialize Terraform:**

```bash
terraform init
```

2. **Plan the Deployment**:

```bash
terraform plan
```

3. **Apply the Configuration**:

```bash
terraform apply
```

4. **Review Outputs**:

   - Key outputs include the ALB DNS name, ASG details, RDS endpoint, and Bastion Host public IP.

## Cleanup

To destroy all resources created by this Terraform configuration, run the following command:

```bash
terraform destroy
```

## Debugging & SSH Access

- **Bastion Host Access**:

  - The bastion host is deployed in a public subnet and is intended for debugging purposes. You can SSH into the bastion host using your key pair. From the bastion host, you can then SSH into your private EC2 instances using their private IPs.

- **Example SSH Workflow**:

1. SSH into the bastion host:

```bash
ssh -A -i ~/.ssh/id_rsa ec2-user@<bastion_public_ip>
```

2. From the bastion host, connect to a private instance:

```bash
ssh ec2-user@<private_instance_ip>
```

3. Troubleshooting 502 Errors:
   - A 502 Bad Gateway error from the ALB indicates that the backend (EC2) instances are not responding correctly. Check:

- Target group health checks and instance status.
- Nginx service on the instances.
- That the user data script executed successfully (for bootstrapping Nginx and copying web files).

## Troubleshooting & Tips

- **State Management**:
  - Verify that your S3 bucket and DynamoDB table for remote state are properly configured.
- **Scaling**:
  - Adjust the Auto Scaling Group parameters based on application load.
- **Security**:
  - Follow least-privilege principles when configuring IAM roles and security groups.
- **Bastion Host**:
  - Use the bastion host to troubleshoot and debug issues by connecting to your private instances without exposing them directly.

## Deployment Preview

### VPC Resource Map:

![VPC Resource Map](assets/vpc_resource_map.png)

- VPC (10.0.0.0/16)
  - 2 Private Subnets (10.0.3.0/24, 10.0.4.0/24)
  - 2 Public Subnets (10.0.1.0/24, 10.0.2.0/24)
  - Internet Gateway (igw-multitier-app-vpc)
  - NAT Gateway (nat-multitier-app-vpc)
  - Route Tables
    - Private (private-rt-multitier-app-vpc)
    - Public (public-rt-multitier-app-vpc)

### ALB Resource Map:

![ALB Resource Map](assets/alb_resource_map.png)

- ALB (multitier-app-alb)
  - Listener (HTTP, HTTPS)
  - Target Group (multitier-app-tg)
  - Targets (multitier-app-nginx-lt-instance)

### EC2 Instances:

![EC2 Instances](assets/ec2_instances.png)

- Nginx Web Server (multitier-app-nginx-lt-instance)
- Bastion Instance (bastion)

### Serving Page

![HTTP Requests](assets/http_request.png)
