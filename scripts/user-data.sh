#!/bin/bash
# Three-Tier Web Application - EC2 User Data Script
# Author: Muralidharan M.N

yum update -y
yum install -y httpd
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>AWS Three-Tier Architecture</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: Arial, sans-serif;
            background-color: #232F3E;
            color: white;
            padding: 30px;
        }
        .header {
            text-align: center;
            padding: 30px;
            background: linear-gradient(135deg, #FF9900, #232F3E);
            border-radius: 15px;
            margin-bottom: 30px;
        }
        .header h1 { 
            font-size: 36px; 
            color: white;
            margin-bottom: 10px;
        }
        .header p { 
            font-size: 18px; 
            color: #FF9900; 
        }
        .built-by {
            font-size: 16px;
            color: #ccc;
            margin-top: 10px;
        }
        .tiers {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .tier {
            background-color: #37475A;
            padding: 25px;
            border-radius: 10px;
            width: 280px;
            text-align: center;
            border-top: 4px solid #FF9900;
        }
        .tier h2 {
            color: #FF9900;
            margin-bottom: 15px;
            font-size: 18px;
        }
        .tier p {
            color: #ccc;
            margin: 5px 0;
            font-size: 14px;
        }
        .tier .service {
            background-color: #232F3E;
            padding: 8px;
            border-radius: 5px;
            margin: 8px 0;
            color: white;
            font-weight: bold;
        }
        .services {
            text-align: center;
            margin-bottom: 30px;
        }
        .services h2 {
            color: #FF9900;
            margin-bottom: 20px;
            font-size: 24px;
        }
        .services-grid {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        .service-badge {
            background-color: #37475A;
            padding: 10px 20px;
            border-radius: 20px;
            color: #FF9900;
            font-weight: bold;
            font-size: 14px;
        }
        .highlights {
            text-align: center;
            margin-bottom: 30px;
        }
        .highlights h2 {
            color: #FF9900;
            margin-bottom: 20px;
            font-size: 24px;
        }
        .highlights-grid {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        .highlight {
            background-color: #37475A;
            padding: 20px;
            border-radius: 10px;
            width: 200px;
            text-align: center;
        }
        .highlight .icon {
            font-size: 30px;
            margin-bottom: 10px;
        }
        .highlight h3 {
            color: #FF9900;
            margin-bottom: 5px;
            font-size: 16px;
        }
        .highlight p {
            color: #ccc;
            font-size: 13px;
        }
        .footer {
            text-align: center;
            padding: 20px;
            color: #ccc;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>☁️ AWS Three-Tier Web Application</h1>
        <p>Production-Ready Cloud Architecture</p>
        <p class="built-by">Built by: Muralidharan M.N | Cloud Engineer Portfolio Project</p>
    </div>

    <div class="tiers">
        <div class="tier">
            <h2>🌐 Tier 1</h2>
            <h2>Presentation Layer</h2>
            <div class="service">Application Load Balancer</div>
            <p>Internet-facing</p>
            <p>Public Subnet</p>
            <p>us-east-1a and us-east-1b</p>
        </div>
        <div class="tier">
            <h2>⚙️ Tier 2</h2>
            <h2>Application Layer</h2>
            <div class="service">Amazon EC2 + Auto Scaling</div>
            <p>Private Subnet</p>
            <p>Min: 2 | Max: 4 instances</p>
            <p>Server: HOSTNAME</p>
        </div>
        <div class="tier">
            <h2>🗄️ Tier 3</h2>
            <h2>Data Layer</h2>
            <div class="service">Amazon RDS MySQL</div>
            <p>Multi-AZ Deployment</p>
            <p>Private Subnet</p>
            <p>Automated Backups</p>
        </div>
    </div>

    <div class="highlights">
        <h2>⭐ Key Features</h2>
        <div class="highlights-grid">
            <div class="highlight">
                <div class="icon">🔒</div>
                <h3>Security</h3>
                <p>3 Security Groups with least privilege access</p>
            </div>
            <div class="highlight">
                <div class="icon">📈</div>
                <h3>Auto Scaling</h3>
                <p>Scales from 2 to 4 instances based on CPU</p>
            </div>
            <div class="highlight">
                <div class="icon">🌍</div>
                <h3>High Availability</h3>
                <p>Deployed across 2 Availability Zones</p>
            </div>
            <div class="highlight">
                <div class="icon">📊</div>
                <h3>Monitoring</h3>
                <p>CloudWatch Dashboard and CPU Alarms</p>
            </div>
        </div>
    </div>

    <div class="services">
        <h2>🛠️ AWS Services Used</h2>
        <div class="services-grid">
            <span class="service-badge">Amazon VPC</span>
            <span class="service-badge">Amazon EC2</span>
            <span class="service-badge">Auto Scaling Group</span>
            <span class="service-badge">Application Load Balancer</span>
            <span class="service-badge">Amazon RDS MySQL</span>
            <span class="service-badge">Security Groups</span>
            <span class="service-badge">Amazon CloudWatch</span>
            <span class="service-badge">Amazon SNS</span>
            <span class="service-badge">NAT Gateway</span>
        </div>
    </div>

    <div class="footer">
        <p>© 2026 Muralidharan M.N | AWS Three-Tier Architecture Portfolio Project</p>
    </div>
</body>
</html>
EOF
sed -i "s/HOSTNAME/$(hostname)/g" /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
