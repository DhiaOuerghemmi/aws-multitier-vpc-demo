# Design Decisions

- **CIDR Choices**  
  - VPC `10.0.0.0/16` gives flexibility for multiple /24 sub-CIDRs.  
  - Public: `10.0.10.0/24` & `10.0.20.0/24`; Private: `10.0.100.0/24` & `10.0.200.0/24`.

- **High Availability**  
  - Two NAT Gateways (one per AZ) avoid cross-AZ data charges and single-point failures.  
  - ALB spans both public subnets to balance across private-subnet EC2.

- **Security Groups**  
  - `ALBSG`: inbound HTTP 80 from 0.0.0.0/0; outbound all.  
  - `WebSG`: inbound HTTP only from `ALBSG` security group; outbound all.

- **SSM for EC2**  
  - Using `AmazonSSMManagedInstanceCore` role lets you patch & debug instances without SSH keys.

- **Auto Scaling**  
  - Desired 4 ensures at least two per AZ. Min 2/Max 6 balances cost vs resilience.
