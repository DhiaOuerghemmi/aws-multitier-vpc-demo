#!/bin/bash
set -e

# Example cleanup—WARNING: adjusts to your names/IDs
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name ASG --force-delete
aws autoscaling delete-launch-configuration --launch-configuration-name WebTemplate || true
aws elbv2 delete-load-balancer --names WebALB
aws elbv2 delete-target-group --names WebTG
# Remove VPC dependencies: EC2s, NATs, IGW, subnets, RTs...
echo "Now go to AWS Console → VPC to delete remaining resources."
