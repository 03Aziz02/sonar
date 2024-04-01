#!/bin/bash

# Update system packages
sudo yum update -y

# Install Java 1.8
sudo yum install -y java-1.8.0-openjdk-devel

# Navigate to /opt directory
cd /opt

# Download SonarQube 7.6
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.6.zip

# Unzip SonarQube
sudo unzip sonarqube-7.6.zip

# Create SonarQube group
sudo groupadd sonar

# Create SonarQube user
sudo useradd -c "Sonar System User" -d /opt/sonarqube-7.6 -g sonar -s /bin/bash sonar

# Set ownership and permissions
sudo chown -R sonar:sonar /opt/sonarqube-7.6
sudo chmod -R 775 /opt/sonarqube-7.6/

# Configure SonarQube to run as user 'sonar'
sudo sed -i "s/#RUN_AS_USER=/RUN_AS_USER=sonar/" /opt/sonarqube-7.6/bin/linux-x86-64/sonar.sh

# Create systemd service file for SonarQube
sudo bash -c 'cat <<-EOF >/etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube-7.6/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube-7.6/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

# Start SonarQube service
sudo systemctl start sonarqube.service

# Enable SonarQube service to start on boot
sudo systemctl enable sonarqube.service

# Create userdata.complete file
sudo touch /userdata.complete
