# Production-Grade Terraform on AWS

A hands-on Terraform learning project focused on building real-world AWS infrastructure using production-style architecture, reusable modules, secure networking, and Terraform best practices.

---

# Project Goal

The purpose of this repository is to learn Terraform deeply through practical implementation instead of just creating random resources.

This project covers:

- Modular Terraform architecture
- AWS networking fundamentals
- Production-grade VPC design
- Public & private subnet architecture
- NAT Gateway & Internet Gateway
- Security Groups & Bastion architecture
- EC2 provisioning
- Remote state management
- Terraform advanced concepts
- Infrastructure composition
- Reusable modules

---

# Current Architecture

```text
                           Internet
                               │
                    ┌──────────▼──────────┐
                    │   Internet Gateway  │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │    Public Subnet    │
                    │    10.0.1.0/24      │
                    └──────────┬──────────┘
                               │
                  ┌────────────▼────────────┐
                  │      Bastion EC2        │
                  │   Public IP Attached    │
                  └────────────┬────────────┘
                               │
                               │ SSH
                               │
                    ┌──────────▼──────────┐
                    │    Private Subnet   │
                    │    10.0.2.0/24      │
                    └──────────┬──────────┘
                               │
                  ┌────────────▼────────────┐
                  │      Private EC2        │
                  │     No Public IP        │
                  └────────────┬────────────┘
                               │
                    ┌──────────▼──────────┐
                    │     NAT Gateway     │
                    └──────────┬──────────┘
                               │
                           Internet
```

---

# Repository Structure

```text
Prod-grade/
│
├── bootstrap/
│   ├── main.tf
│   ├── dynamodb.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   └── bootstrap.tfvars
│
├── environments/
│   └── dev/
│       ├── backend.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       ├── outputs.tf
│       └── providers.tf
│
├── modules/
│   ├── vpc/
│   ├── security-groups/
│   └── ec2/
│
├── versions.tf
└── .gitignore
```

---

# Infrastructure Components

## Networking

### VPC
- Custom CIDR range
- DNS support enabled
- DNS hostnames enabled

### Public Subnet
Used for:
- Bastion Host
- NAT Gateway

### Private Subnet
Used for:
- Internal EC2 workloads
- Secure infrastructure

### Internet Gateway
Provides internet connectivity to public subnet.

### NAT Gateway
Allows outbound internet access for private subnet resources without exposing them publicly.

### Route Tables
Controls traffic routing between:
- local VPC traffic
- internet traffic
- NAT traffic

---

# Security Architecture

## Bastion Host Pattern

```text
Laptop → Bastion Host → Private EC2
```

### Bastion Security Group
Allows:
- SSH (22)
- ONLY from personal public IP

### Private EC2 Security Group
Allows:
- SSH ONLY from Bastion Security Group

No direct internet access to private workload.

---

# Terraform Concepts Covered

## Core Concepts
- Providers
- Variables
- Outputs
- Modules
- Resource references
- Terraform state
- Remote backend

---

## Intermediate Concepts
- Locals
- Dependency graph
- Module chaining
- Reusable infrastructure
- Environment segregation

---

## Advanced Concepts (Upcoming)
- Data sources
- `for_each`
- `count`
- Dynamic blocks
- Conditionals
- Maps & objects
- Lifecycle rules
- Workspaces
- Remote modules
- CI/CD integration

---

# Remote Backend

Terraform state is stored remotely using:

| Service | Purpose |
|---|---|
| S3 | Remote Terraform state |
| DynamoDB | State locking |

---

# Backend Configuration

```hcl
terraform {
  backend "s3" {
    bucket         = "gb-tf-state-2026"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
```

---

# Prerequisites

Before running this project ensure:

- AWS account configured
- AWS CLI installed
- Terraform installed
- SSH keypair created in AWS
- IAM user with sufficient permissions

---

# Terraform Version

```text
Terraform >= 1.5
AWS Provider >= 5.x
```

---

# Bootstrap Setup

The bootstrap folder creates:
- S3 backend bucket
- DynamoDB lock table

## Run Bootstrap

```bash
cd bootstrap

terraform init
terraform apply -var-file="bootstrap.tfvars"
```

---

# Deploy Development Environment

```bash
cd environments/dev

terraform init
terraform plan
terraform apply
```

---

# Useful Terraform Commands

## Format Code

```bash
terraform fmt -recursive
```

---

## Validate Configuration

```bash
terraform validate
```

---

## View Execution Plan

```bash
terraform plan
```

---

## Apply Infrastructure

```bash
terraform apply
```

---

## Destroy Infrastructure

```bash
terraform destroy
```

---

# SSH Access Flow

## Step 1 — SSH into Bastion

```bash
ssh -i lvm-login-key.pem ubuntu@<BASTION_PUBLIC_IP>
```

---

## Step 2 — SSH into Private EC2

```bash
ssh -i lvm-login-key.pem ubuntu@<PRIVATE_EC2_IP>
```

---

# Important Notes

## NAT Gateway Costs Money
NAT Gateway is NOT free tier eligible.

Destroy infrastructure after practice if not required.

---

## Keep PEM Files Secure
Never commit:
- `.pem`
- `.tfstate`
- `.tfvars`

to GitHub.

---

# Suggested .gitignore

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.pem
terraform.tfvars
.terraform.lock.hcl
```

---

# Learning Roadmap

## Completed
- VPC
- Subnets
- Route Tables
- NAT Gateway
- Security Groups
- Bastion Architecture
- EC2 Provisioning
- Remote Backend
- Terraform Locals

---

## Next Topics
- Data Sources
- Dynamic Infrastructure
- Multi-AZ Architecture
- Application Load Balancer
- Auto Scaling
- RDS
- IAM Roles
- SSM Session Manager
- CI/CD Pipelines
- ECS/EKS

---

# Key Learning Outcomes

By completing this project you will understand:

- How production AWS networking works
- Public vs private subnet architecture
- Route table design
- NAT Gateway behavior
- Bastion host architecture
- Terraform module design
- Terraform state management
- Infrastructure composition
- Secure cloud infrastructure patterns

---

# Future Improvements

Planned enhancements:

- Multi-AZ support
- Reusable subnet creation using `for_each`
- Dynamic Security Groups
- Auto Scaling Groups
- ALB integration
- SSM Session Manager
- Terraform Cloud integration
- GitHub Actions CI/CD
- Monitoring & logging stack

---

# Author

Built as a practical Terraform mastery project focused on real-world AWS infrastructure engineering.