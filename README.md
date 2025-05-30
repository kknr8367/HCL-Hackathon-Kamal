
# HCL Hackathon - DevOps Kamal

## Overview
This project sets up a DevOps infrastructure on AWS for the HCL Hackathon - Kamal using Terraform and GitHub Actions CI/CD. It provisions necessary AWS resources including IAM, VPC, ECS Fargate, ECR, ALB, and Security Groups.

<img width="466" alt="image" src="https://github.com/user-attachments/assets/4ec76750-af8c-48a8-949a-a0ea53a10789" />

---

## AWS Resources Provisioned
### IAM
- Creates a role for ECS Fargate Cluster and assigns it.
- Grants ECR Registry Admin Access.
- Provides access key and secret key for Terraform.

### VPC
- Creates a VPC (`CIDR: 10.0.0.0/16`).
- Includes:
  - Internet Gateway
  - NAT Gateway
  - Public and Private Subnets
  - Route Table

### ECR Registry
- Creates an ECR Registry named `hcl-hackathon-devops-kamal-ecr`.

### Security Groups
- ECS Fargate Cluster Security Group: Allows inbound traffic on ports 80 and 443.
- Application Load Balancer Security Group: Allows inbound traffic on ports 80 and 443.

### Application Load Balancer
- Creates an Application Load Balancer (`hcl-hackathon-devops-kamal-ALB`).
- Creates a Target Group (`hcl-hackathon-devops-kamal-TG`).

### ECS Fargate Cluster
- Deploys an ECS Fargate Cluster named `hcl-hackathon-devops-kamal-ECSFargate`.

## Cloudwatch
- CloudWatch Log Groups to store container logs
- CloudWatch Alarms to monitor CPU and memory utilization
- CloudWatch Container Insights for ECS task performance tracking
- CloudWatch and AWS SNS integration for alert notifications
- Terraform automation to deploy all configurations


SonarQube Integration for Code Quality Analysis
- What is SonarQube? SonarQube is an open-source tool for static code analysis, identifying bugs, vulnerabilities, and code smells in multiple programming languages.
- How to Implement SonarQube in CI/CD Pipeline
- Install SonarQube on a server or use SonarCloud (cloud-based version).

Key Features of SonarQube
- Code Quality Checks: Detects issues in Python, Java, JavaScript, Terraform, and more.
- Security Analysis: Identifies potential vulnerabilities (SQL injection, XSS).
- Automated Review: Flags violations against best practices and coding standards.
- Reports & Dashboards: Provides detailed metrics via the SonarQube Web UI.
- Add the SonarQube GitHub Action for automated scanning:

##SonarQube Code:
- name: SonarQube Scan
  uses: SonarSource/sonarqube-scan-action@v2
  env:
    SONAR_TOKEN: ${{ secrets.SONARQUBE_TOKEN }}
    SONAR_HOST_URL: "https://sonar.yourdomain.com"

## Folder Structure
```
HCL-Hackathon-DevOps-Kamal
|- Dockerfile
|- index.js
├─ Terraform
├─── Module
│   ├─── ecr_registry.tf
│   ├─── iam.tf
│   ├─── security_group.tf
│   ├─── vpc.tf
│   ├─── alb.tf
│   ├─── ecs_fargate.tf
│   ├─── variables.tf
│   └─── main.tf
└─── main.tf
```

---

## CI/CD Pipeline
### GitHub Actions
- Automates deployment and infrastructure provisioning using Terraform.
- Integrates CI/CD for streamlined updates.

---

## Setup Instructions
1. Clone the repository:
   git clone https://github.com/your-repo/hcl-hackathon-devops-kamal.git

2. Navigate to the project directory:
   cd hcl-hackathon-devops-kamal

3. Initialize Terraform:
   terraform init
 
4. Apply Terraform configuration:
   terraform apply -auto-approve

5. Deploy application using ECS.


.github/workflow
├─── main.yml

-----
name: Deploy to AWS ECS Fargate

on:
  push:
    branches:
      - main

jobs:
  terraform:
    name: Terraform Apply
    runs-on: ubuntu-latest / aws/linux/amd64/latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Initialize Terraform
        run: terraform init

      - name: Check Terraform Configuration
        run: terraform plan

      - name: Apply Terraform configuration
        run: terraform apply -auto-approve
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

  deploy:
    name: Deploy to ECS Fargate
    runs-on: ubuntu-latest / aws/linux/amd64/latest
    needs: terraform
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Authenticate AWS CLI
        run: |
          aws configure set aws_access_key_id ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws configure set aws_secret_access_key ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws configure set region us-east-1

      - name: Build and Push Docker Image
        run: |
          docker build -t ${{ secrets.AWS_ECR_REPO }} .
          aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${{ secrets.AWS_ECR_REPO }}
          docker tag ${{ secrets.AWS_ECR_REPO }}:latest ${{ secrets.AWS_ECR_REPO }}:latest
          docker push ${{ secrets.AWS_ECR_REPO }}:latest

      - name: Deploy Application
        run: |
          aws ecs update-service --cluster hcl-hackathon-devops-kamal-ECSFargate \
          --service hcl-service \
          --force-new-deployment
