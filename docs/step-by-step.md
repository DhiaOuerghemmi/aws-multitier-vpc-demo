# Step-by-Step Console Guide

1. **Create VPC**  
   - Go to **VPC > Your VPCs > Create VPC**  
   - Name: `MyVPC`  
   - CIDR: `10.0.0.0/16`  
   - Enable DNS hostname ✅  
   - ![vpc-overview](../screenshots/vpc-overview.png)

2. **Public Subnet 1**  
   - **VPC > Subnets > Create Subnet**  
   - Name: `Public_Subnet1`  
   - AZ: `us-east-1a`  
   - CIDR: `10.0.10.0/24`  
   - Enable Auto-assign Public IPv4 ✅  
   - ![subnet-public1](../screenshots/subnet-public1.png)

3. **Public Subnet 2**  
   - Same as above, AZ `us-east-1b`, CIDR `10.0.20.0/24`  
   - ![subnet-public2](../screenshots/subnet-public2.png)

4. **Internet Gateway**  
   - **VPC > Internet Gateways > Create**  
   - Attach to `MyVPC`  
   - ![igw](../screenshots/igw.png)

5. **Public Route Table**  
   - **VPC > Route Tables > Create**  
   - Name: `Public_RT`  
   - Associate with both Public_Subnet1 & Public_Subnet2  
   - Add Route: `0.0.0.0/0` → IGW  
   - ![public-rt](../screenshots/public-rt.png)

6. **Private Subnets**  
   - Create two subnets:  
     - `Private_Subnet1` (us-east-1a, 10.0.100.0/24)  
     - `Private_Subnet2` (us-east-1b, 10.0.200.0/24)  
   - ![subnet-private](../screenshots/subnet-private.png)

7. **NAT Gateways**  
   - **VPC > NAT Gateways > Create**  
   - Name: `NAT_A`, Subnet: Public_Subnet1, allocate Elastic IP  
   - Repeat for `NAT_B` in Public_Subnet2  
   - ![nat-gateway](../screenshots/nat-gateway.png)

8. **Private Route Tables**  
   - Create `Private_RT_1`, associate Private_Subnet1, route `0.0.0.0/0` → NAT_A  
   - Create `Private_RT_2`, associate Private_Subnet2, route `0.0.0.0/0` → NAT_B  
   - ![private-rt](../screenshots/private-rt.png)

9. **IAM Role for SSM**  
   - **IAM > Roles > Create role**  
   - Trusted Entity: EC2  
   - Attach policy: `AmazonSSMManagedInstanceCore`  
   - Name: `ec2-to-ssm`  
   - ![ec2-ssm-role](../screenshots/ec2-ssm-role.png)

10. **EC2 Instances**  
    - **EC2 > Instances > Launch**  
    - AMI: Amazon Linux 2023; Type: t2.micro  
    - Network: MyVPC → Private_Subnet1 (no pub IP)  
    - IAM role: ec2-to-ssm  
    - Security Group: `WebSG` (inbound HTTP 80 from anywhere)  
    - Add user data: `scripts/bootstrap-web.sh` (Server 1)  
    - Repeat for Private_Subnet2 (Server 2)  
    - ![ec2-instances](../screenshots/ec2-instances.png)

11. **Target Group & ALB**  
    - **EC2 > Target Groups > Create**  
      - Name: `WebTG`, Protocol: HTTP, Port: 80, VPC: MyVPC  
      - Register both instances  
    - **EC2 > Load Balancers > Create**  
      - Name: `WebALB`, Scheme: internet-facing, AZs: both publics  
      - Security Group: `ALBSG` (inbound HTTP 80)  
      - Listener HTTP 80 → WebTG  
    - ![alb-config](../screenshots/alb-config.png)

12. **Auto Scaling**  
    - **EC2 > Launch Templates > Create**  
      - Name: `WebTemplate`, AMI: Linux 2023, SG: WebSG, user data: `bootstrap-asg.sh`  
    - **EC2 > Auto Scaling Groups > Create**  
      - Name: `ASG`, Template: WebTemplate, VPC: MyVPC → Private_Subnet1 & 2  
      - Desired: 4, Min: 2, Max: 6  
      - Attach to ALB → WebTG, enable ALB health checks  
    - ![asg-config](../screenshots/asg-config.png)

13. **Lock Down Security Groups**  
    - Edit `WebSG` inbound → only allow source = `ALBSG`  
    - Edit `ALBSG` outbound → only allow HTTP to `WebSG`

14. **Verify & Cleanup**  
    - Test ALB DNS in browser  
    - To teardown: run `scripts/cleanup-aws-cli.sh` or delete via Console  
