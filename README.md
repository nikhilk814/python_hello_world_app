# Hello-world-python-app
## Continuous Integration and Continuous Delivery (CI/CD) pipeline and deploy code changes to production. Using git, github, Jenkins, and Docker, AWS EC2 by building a Hello-World application, building, testing, and deploying it to Docker Hub.

## Objectives
- Containerize a simple Flask application using Docker to make it more portable and scalable.
-	Use Git to manage the application's source code to facilitate collaboration and version control updates.
-	Implement Infrastructure as Code for automated build, test, and deployment process using Jenkins pipeline script.
-	Ensure Continuous Integration of the application by configuring Jenkins to automatically build and test every time code changes are made.
-	Implement Continuous Delivery/Deployment by configuring Jenkins to automatically deploy the application to a Docker registry when the build and test phases are successful.

## Pre-requisites
-	AWS account and EC2.
-	Docker Hub account.
-	Git version control and experience with command line interface.
-	Github account.
-	Jenkins Pipeline

## AWS EC2 Instance
- Go to AWS Console
- Instances(running)
- Launch instances
- AMI: Ubuntu Server 22.04 LTS (free tier eligible)
- Instance type: t2.micro
- Key pair: Select or create your own
- Network settings: Create your own security group allowing SSH traffic from Anywhere for the purpose of this project. Leave everything else as the default settings. After launching your instance, go to your security groups and edit the one associated to your EC2 to add port 8080 or all traffic to Anywhere.
- Configure storage: 1x8 GiB gp2
- Launch the instance and then connect to it with SSH.
  
![Screenshot 2023-10-20 101330](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/927c65cf-2637-4d9f-860e-dfeae4d43384)

![aws-image](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/73a680a4-7799-4a1f-90cb-287214625a20)

![image](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/66368122-0c3d-4607-8776-822dd6e86f7a)

![instance](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/c132a4b9-8068-4ce7-9b9a-1cff55ac6ec7)

## Connect ec2 using ssh in MobaXterm  terminal

![ssh](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/1779d7db-3253-4a0a-b1eb-af727df06ff4)

```
## Install Jenkins with the following script.
#!/bin/bash
# This script installs Jenkins on an Ubuntu server

# Update package lists
sudo apt-get update

# Install Java 11
sudo apt-get install -y openjdk-11-jdk

# Download Jenkins key and add it to system
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins to system package source list
sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null'

# Update package lists again to include Jenkins and install it
sudo apt-get update
sudo apt-get install -y jenkins

# Verify Jenkins is installed and working
sudo systemctl status jenkins
```






