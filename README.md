#  AWS Three-Tier Web Application

##  Project Overview

A **production-ready three-tier web application** deployed on AWS,
demonstrating high availability, horizontal scaling, and
network security best practices.

---

## Architecture Diagram
<img width="1536" height="1024" alt="Three tier web application architecture diagram" src="https://github.com/user-attachments/assets/9b982c34-2b20-4837-9c9b-014a2b7c23dd" />




---

##  AWS Services Used

| Service | Purpose |
|---------|---------|
| **Amazon VPC** | Custom network with public and private subnets |
| **Amazon EC2** | Application servers in private subnets |
| **EC2 Auto Scaling** | Automatic scaling based on CPU utilization |
| **Application Load Balancer** | Traffic distribution across EC2 instances |
| **Amazon RDS MySQL** | Highly available database with Multi-AZ |
| **Security Groups** | Layered firewall rules between tiers |
| **NAT Gateway** | Internet access for private subnet resources |
| **Amazon CloudWatch** | Monitoring and alerting |
| **Amazon SNS** | CPU alarm notifications |
| **AWS IAM** | EC2 instance role for Session Manager |
| **AWS Systems Manager** | Session Manager for private EC2 access |

---

## Security Architecture

Three security groups implement defense in depth:
<img width="1149" height="1369" alt="Security architecture" src="https://github.com/user-attachments/assets/a77ab7e7-6307-4558-b0b3-8b716e10c220" />



---

## Network Design

| Component | Details |
|-----------|---------|
| **VPC CIDR** | 10.0.0.0/16 |
| **Public Subnet 1** | us-east-1a (ALB + NAT Gateway) |
| **Public Subnet 2** | us-east-1b (ALB) |
| **Private Subnet 1** | us-east-1a (EC2 App Servers) |
| **Private Subnet 2** | us-east-1b (EC2 App Servers) |
| **Private Subnet 3** | us-east-1a (RDS Primary) |
| **Private Subnet 4** | us-east-1b (RDS Standby) |
| **Availability Zones** | 2 (High Availability) |
| **NAT Gateway** | 1 (in public subnet) |

---

## Auto Scaling Configuration

| Setting | Value |
|---------|-------|
| **Minimum instances** | 2 |
| **Desired instances** | 2 |
| **Maximum instances** | 4 |
| **Scale out trigger** | CPU > 70% |
| **Scale in trigger** | CPU < 70% |

---

## Database Configuration

| Setting | Value |
|---------|-------|
| **Engine** | MySQL 8.4.8 |
| **Instance class** | db.t3.micro |
| **Multi-AZ** | Yes (High Availability) |
| **Public access** | No (Private subnet only) |
| **Automated backups** | Enabled |

---

##  Monitoring Setup

| Component | Details |
|-----------|---------|
| **CloudWatch Dashboard** | EC2 CPU Utilization, ALB requests, database connections |
| **CPU Alarm** | Triggers when CPU Utilization> 80% |
| **SNS Notification** | Email alerts for alarms |

---

## 🚀 Implementation Steps

| Step | Task | Status |
|------|------|--------|
| 1 | Design Network — VPC with public and private subnets | ✅ |
| 2 | Set Up Security — 3 Security Groups | ✅ |
| 3 | Deploy Database Tier — RDS MySQL Multi-AZ | ✅ |
| 4 | Create Application Tier — EC2 in private subnets | ✅ |
| 5 | Configure Auto Scaling — CPU Utilization target based scaling | ✅ |
| 6 | Implement Load Balancing — ALB in public subnets | ✅ |
| 7 | Build Presentation Tier — Apache web server | ✅ |
| 8 | Establish Connectivity — EC2 to RDS verified | ✅ |

---

## 💡 Key Learnings

1. **Security Groups Chain** — Learned how to create proper security chain between tiers ensuring database is never directly accessible from internet

2. **Multi-AZ RDS** — Understood how standby instance automatically takes over if primary RDS fails ensuring zero downtime

3. **Auto Scaling** — Learned how Auto Scaling group maintains desired capacity and automatically scales based on CPU metrics

4. **Load Balancer Health Checks** — Discovered that incorrect security group on ALB causes health check failures and targets become unhealthy

5. **Session Manager** — Used IAM roles and SSM to securely connect to private EC2 instances without needing SSH or bastion host

6. **NAT Gateway** — Understood how private subnet resources access internet through NAT Gateway without being publicly exposed

---
## ⚠️ Challenges Faced and How I Fixed Them

### Challenge 1 — Wrong Security Group on ALB

**What happened:**
When I created the Auto Scaling Group and let it automatically 
create the Load Balancer, AWS attached SG-App to the ALB 
instead of SG-ALB. This broke the entire security chain because:
- ALB needs SG-ALB to accept incoming internet traffic
- EC2 needs SG-App to accept traffic only from ALB
- Having SG-App on ALB meant traffic could not flow correctly
- All targets in Target Group showed "Unhealthy" status

**How I debugged it:**
1. Noticed all targets were showing "Unhealthy" in Target Group
2. Checked EC2 System Log — Apache web server was running correctly
3. Checked Route Tables — NAT Gateway was configured correctly
4. Checked SG-App inbound rules — rules were correct
5. Finally inspected ALB Security tab and discovered SG-App 
   was attached instead of SG-ALB!

**How I fixed it:**
1. Went to EC2 → Load Balancers → clicked project-alb
2. Clicked Security tab
3. Clicked Edit security groups
4. Removed SG-App by clicking X next to it
5. Selected SG-ALB from dropdown
6. Clicked Save changes
7. Waited 2-3 minutes for health checks to pass
8. All targets immediately became Healthy! ✅

**What I learned:**
Never let Auto Scaling Group create the Load Balancer 
automatically! Always create the Load Balancer manually first 
and explicitly assign the correct security group. 
This experience taught me to always verify the complete 
security group chain:
Internet → SG-ALB → SG-App → SG-DB

---

### Challenge 2 — Session Manager Not Connecting

**What happened:**
When I tried to connect to private EC2 instance via 
AWS Session Manager, I got this error:
"SSM Agent unable to acquire credentials — 
AccessDeniedException: Systems Manager instance 
management role is not configured for account"

This meant I could not access my private EC2 instance 
at all to test the RDS connectivity!

**How I debugged it:**
1. Checked the exact error message — 
   "no valid credentials could be retrieved for ec2 identity"
2. This clearly indicated the EC2 instance had no IAM role 
   attached to authenticate with AWS Systems Manager
3. Without an IAM role the SSM Agent on EC2 cannot 
   communicate with Systems Manager service

**How I fixed it:**
1. Went to IAM → Roles → Create role
2. Selected AWS service → EC2 as trusted entity
3. Searched for AmazonSSMManagedInstanceCore policy
4. Selected it and clicked Next
5. Named the role EC2-SSM-Role
6. Clicked Create role
7. Went to EC2 → Instances → selected running instance
8. Clicked Actions → Security → Modify IAM role
9. Selected EC2-SSM-Role from dropdown
10. Clicked Update IAM role
11. Waited 3 minutes for role to take effect
12. Went back to Connect → Session Manager → Connected successfully! ✅

**What I learned:**
EC2 instances in private subnets need an IAM role with 
AmazonSSMManagedInstanceCore policy to use Session Manager.
This is actually MORE SECURE than SSH because:
- No inbound port 22 needs to be opened
- No SSH key management required
- All sessions are logged in CloudWatch
- Access is controlled through IAM policies

---

### Challenge 3 — MySQL Package Not Found on EC2

**What happened:**
After connecting to EC2 via Session Manager, I tried to 
install MySQL client to test RDS connectivity by running:
sudo yum install -y mysql
But got error: "No match for argument: mysql"

Then tried:
sudo dnf install -y mysql → Failed
sudo yum install -y mysql80-community-release → Failed

I could not connect to RDS database without MySQL client!

**How I debugged it:**
1. Noticed the error said "No match for argument: mysql"
2. Checked the EC2 instance details — it was running 
   Amazon Linux 2023 NOT Amazon Linux 2
3. Realized Amazon Linux 2023 uses different package 
   names and dnf package manager instead of yum
4. Amazon Linux 2023 does not have mysql package 
   in its default repository

**How I fixed it:**
1. Searched for correct MySQL package for Amazon Linux 2023
2. Found that mariadb105 is the correct MySQL compatible 
   client for Amazon Linux 2023
3. Ran: sudo dnf install -y mariadb105
4. Installation completed successfully! ✅
5. Connected to RDS using:
   mysql -h project-db.cu5ou4mmuxe2.us-east-1.rds.amazonaws.com -u admin -p
6. Got "Welcome to the MariaDB monitor" message
7. Successfully ran show databases and CREATE DATABASE commands!

**What I learned:**
Always check which Amazon Linux version your EC2 is 
running before installing packages:
- Amazon Linux 2 → use yum install mysql
- Amazon Linux 2023 → use dnf install mariadb105

This taught me the importance of understanding the 
underlying OS when working with EC2 instances!

## 💰 Cost Considerations

| Resource | Approximate Monthly Cost |
|----------|------------------------|
| EC2 t2.micro x2 | Free tier eligible |
| RDS db.t3.micro Multi-AZ | ~$25-50/month |
| NAT Gateway | ~$32/month |
| Application Load Balancer | ~$16/month |

⚠️ **Delete resources after testing to avoid charges!**

---

## 📚 Resources
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc)
- [AWS RDS Documentation](https://docs.aws.amazon.com/rds)
- [AWS EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling)

---

## 👨‍💻 Author

**Muralidharan M.N**
Cloud Engineer | AWS Portfolio Project

---

⭐ If you found this helpful please give it a star!
