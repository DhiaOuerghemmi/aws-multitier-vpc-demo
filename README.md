# AWS Multi-Tier VPC (Manual Console)

**Author:** Your Name  
**Date:** April 2025  

## Overview

This repository documents how to build a multi-tier web application in a custom AWS VPC **by hand** via the AWS Console. It covers:

- VPC, public & private subnets  
- Internet Gateway & NAT Gateways  
- EC2 web/app servers (with SSM IAM role)  
- Application Load Balancer & Target Group  
- Auto Scaling Group (ASG) integration  
- Security Group lockdown & cleanup  

## Contents

- **docs/**  
  - `architecture.png`  
  - `step-by-step.md`  
  - `design-decisions.md`  
  - `user-guide.md`  
- **screenshots/** – console screenshots  
- **scripts/** – helper AWS CLI / user-data scripts  
- **src/** – sample static site  
- `.gitignore`, `LICENSE`

## How to Use

1. Clone this repo  
   ```bash
   git clone https://github.com/your-username/aws-multitier-vpc-manual.git
   cd aws-multitier-vpc-manual
