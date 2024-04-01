sudo yum update -y
sudo yum install -y java-1.8.0-openjdk-devel
cd /opt
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.6.zip
unzip sonarqube-7.6.zip
sudo groupadd sonar
sudo useradd -c "Sonar System User" -d /opt/sonarqube-7.6 -g sonar -s /bin/bash sonar
sudo chown -R sonar:sonar /opt/sonarqube-7.6
sudo chmod -R 775 /opt/sonarqube-7.6/

sudo sed -i "s/#RUN_AS_USER=/RUN_AS_USER=sonar/" /opt/sonarqube-7.6/bin/linux-x86-64/sonar.sh

sudo bash -c 'cat <<-EOF >>/etc/systemd/system/sonarqube.service
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

sudo service sonarqube start
sudo systemctl enable sonarqube.service
sudo touch /userdata.complete
