# User Guide: Verify & Test

## 1. Verify Networking

- In **VPC > Your VPCs**, confirm `MyVPC` with DNS Hostnames ON.  
- In **Subnets**, check four subnets with correct CIDRs and auto-assign on publics.

## 2. Check EC2 & IAM

- **IAM > Roles**: see `ec2-to-ssm`.  
- **EC2 > Instances**: two original web servers and four ASG servers should show “running” and “SSM Managed”.

## 3. Test Web Servers

```bash
# From your laptop (with AWS CLI & Session Manager plugin):
aws ssm start-session --target <InstanceID>
# Inside:
sudo systemctl status httpd   # or h4pd package
curl http://localhost          # should show your greeting message
