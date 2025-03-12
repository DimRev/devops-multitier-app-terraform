# Advanced Terraform Exercise: Deploy a Scalable Multi-Tier Web Application on AWS

## Objective

Design and implement a scalable, secure, and highly available multi-tier web application infrastructure on AWS using Terraform. This exercise will require you to apply advanced Terraform features and AWS services, including modules, remote state management, provisioners, and more.

---

## Overview

You will build the following infrastructure:

- **Networking**
  - A new _VPC_ with public and private subnets spread across multiple Availability Zones (AZs).
  - _Internet Gateway_ for internet access and _NAT Gateways_ for outbound internet access from private subnets.
  - Properly configured _route tables_, _security groups_, and network ACLs.
- **Compute and Load Balancing**
  - An _Auto Scaling Group (ASG)_ of web servers (EC2 instances) in private subnets.
  - An _Application Load Balancer (ALB)_ in public subnets to distribute traffic to the web servers.
- **Database**
  - A _RDS MySQL_ database instance in private subnets, inaccessible from the internet.
- **State Management and Modules**
  - Use _Terraform modules_ to organize your code.
  - Store Terraform state _remotely_ in an S3 bucket with state locking using DynamoDB.
- **Advanced Terraform Features**
  - Implement _provisioners_ to bootstrap EC2 instances.
  - Utilize _data sources_ to fetch dynamic information.
  - Apply _variables_, _outputs_, _interpolation_, _conditionals_, and _loops_.

## Instructions

1. **Setup Remote State Management**
   - **S3 Bucket for State Storage**
     - Create an S3 bucket to store your Terraform state files.
     - Enable versioning on the bucket for state file history.
   - **DynamoDB Table for State Locking**
     - Create a DynamoDB table to enable state locking and prevent concurrent state modifications.
   - **Backend Configuration**
     - Configure your Terraform backend to use the S3 bucket and DynamoDB table.
2. **VPC and Networking**
   - **VPC Creation**
     - Create a VPC with a CIDR block of `10.0.0.0/16`.
   - Subnets
     - Create at least two public subnets and two private subnets across two AZs.
     - Tag subnets appropriately (e.g., `public-1`, `private-1`).
   - **Internet Gateway and NAT Gateways**
     - Attach an Internet Gateway to the VPC.
     - Deploy NAT Gateways in each public subnet for redundancy.
   - **Route Tables**
     - Create and associate route tables for public and private subnets.
       - Public subnets route to the Internet Gateway.
       - Private subnets route to the NAT Gateways.
   - **Security Groups and Network ACLs**
     - Define Security Groups for the ALB, EC2 instances, and RDS.
       - _ALB SG_: Allows inbound HTTP/HTTPS traffic.
       - _EC2 SG_: Allows inbound traffic from ALB SG on HTTP/HTTPS ports.
       - _RDS SG_: Allows inbound traffic from EC2 SG on MySQL port.
     - Configure Network ACLs to add an additional layer of security.
3. **Application Load Balancer (ALB)**
   - **Deployment**
     - Create an ALB in the public subnets.
     - Configure listeners for HTTP (port 80) and HTTPS (port 443).
     - Set up appropriate target groups.
4. **Auto Scaling Group (ASG) and Launch Configuration**
   - **Launch Configuration/Template**
     - Use the latest Amazon Linux 2 AMI (use a data source to fetch).
     - Install Nginx and deploy a simple web application using user data scripts or provisioners.
   - **Auto Scaling Group**
     - Create an ASG using the launch configuration/template.
     - Configure the ASG to span the private subnets across both AZs.
     - Set desired, minimum, and maximum capacity.
     - Implement scaling policies based on CPU utilization.
5. **RDS MySQL Database**
   - **Deployment**
     - Launch an RDS MySQL instance in the private subnets.
     - Use Multi-AZ deployment for high availability.
     - Apply encryption at rest.
     - Configure parameter groups as needed.
   - **Connectivity**
     - Ensure the database is only accessible from the EC2 instances (correct Security Group setup).
6. **IAM Roles and Policies**
   - **EC2 Instance Profile**
     - Create an IAM role and attach it to your EC2 instances.
     - Grant least-privilege permissions, e.g., read access to specific S3 buckets if needed.
   - **S3 Bucket Policies**
     - If your EC2 instances need to access S3, set up appropriate bucket policies.
7. **Terraform Modules**
   - **Module Structure**
     - Organize your Terraform code into reusable modules:
       - _vpc_
       - _alb_
       - _asg_
       - _rds_
       - _security_
     - **Module Usage**
       - Each module should be in its own directory with its own `main.tf`, `variables.tf`, and `outputs.tf`.
8. **Variables and Outputs**
   - **Variables**
     - Externalize configurable parameters using variables.
       - Examples: instance types, key pair names, desired capacity.
     - Outputs
       - Output essential information like ALB DNS name, RDS endpoint, etc.
9. **Provisioners and User Data**
   - **Bootstrapping EC2 Instances**
     - Use provisioners or user data scripts to:
       - Install necessary software (e.g., Nginx, application dependencies).
       - Deploy application code from a repository or S3 bucket.
         **Templates**
     - Use Terraform templates (`.tpl` files) to manage complex scripts.
10. **Advanced Features**
    - **Conditionals and Loops**
      - Use _count_, _for_each_, or _dynamic_ blocks where appropriate.
        - Example: Create resources per AZ using loops.
      - **Data Sources**
        - Utilize data sources to fetch AMIs, VPCs, or other resources dynamically.
      - **Interpolation and Functions**
        - Implement Terraform interpolation and built-in functions to manage resource attributes.
      - **Resource Tagging**
        - Tag all AWS resources according to a consistent tagging strategy.
11. **Documentation and Cleanup**
    - **README.md**
      - Provide a comprehensive README explaining:
        - Architecture diagram or description.
        - How to initialize and deploy the infrastructure.
        - Variables that need to be set.
        - Any prerequisites or dependencies.
      - **Cleanup Instructions**
        - Ensure your Terraform configuration can cleanly destroy all created resources.
        - Provide any additional steps needed to avoid orphaned resources or charges.

## Deliverables

1. **Terraform Codebase**
   - Well-organized code using modules.
   - Properly commented and formatted code.
2. **Documentation**
   - A detailed `README.md` file.
3. **Demonstration**
   - Steps to initialize, plan, and apply the Terraform configuration.
   - Verification of deployed resources.
4. **Cleanup**
   - Instructions or scripts to destroy all infrastructure.

## Requirements and Constraints

- **Terraform Version**
  - Use Terraform version >= 0.12.
- **AWS Account**
  - You will need access to an AWS account with permissions to create the above resources.
  - Be mindful of AWS costs; use free-tier eligible resources where possible.
- **Security Best Practices**
  - Do not hardcode sensitive information (use variables or AWS Secrets Manager).
    Apply the principle of least privilege in IAM policies.
  - Ensure no public access to private resources (EC2 instances, RDS).
- **Code Quality**
  - Follow Terraform best practices.
    Use `.gitignore` to exclude sensitive files if using version control.

## Additional Challenges (Optional)

- **SSL Termination**
  - Configure SSL certificates for the ALB using AWS Certificate Manager.
- **Bastion Host**
  - Implement a bastion host in the public subnet to allow SSH access to EC2 instances in private subnets.
- **Monitoring and Logging**
  - Set up CloudWatch metrics and alarms for critical resources.
  - Enable logging for ALB and store logs in S3.
- **Automated Testing**
  - Use Terraform testing tools like terratest to write automated tests for your infrastructure.
- **CI/CD Integration**
  - Integrate your Terraform deployment with a CI/CD pipeline using tools like Jenkins or GitHub Actions.

## Hints and Tips

- **Resource Naming**
  - Use meaningful names and consider naming conventions for resources.
- **State Management**
  - Be cautious with state files; always back up before major changes.
- **Debugging**
  - Use terraform plan and terraform apply with the -var-file option to manage different environments.
- **Version Control**
  - Commit your code changes incrementally and use meaningful commit messages.

## Estimated Time to Complete

This exercise is comprehensive and may take 6-8 hours to complete, depending on your familiarity with Terraform and AWS services.

## Getting Started

1. **Prepare Your Environment**
   - Install the required Terraform version.
   - Configure AWS CLI with your credentials.
2. **Plan Your Approach**
   - Sketch the architecture.
   - Decide on module structure and resource dependencies.
3. **Incremental Development**
   - Develop and test each module individually before integrating.
4. **Testing**
   - Regularly use terraform validate and terraform fmt.
   - Deploy in a test environment before applying to production (if applicable).
