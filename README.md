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

## Install Jenkins with the following script.
```
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
![jenkins script](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/93755496-6706-4d81-8adc-261c017797da)

![jenkins status](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/b76f08af-c64a-41cd-a5e6-457388d2238e)

**Note: ** By default, Jenkins will not be accessible to the external world due to the inbound traffic restriction by AWS. Open port 8080 in the inbound traffic rules as show below.

- EC2 > Instances > Click on
- In the bottom tabs -> Click on Security
- Security groups
- Add inbound traffic rules as shown in the image (you can just allow TCP 8080 as well, in my case, I allowed All traffic).

## Login to Jenkins using the below URL:
http://:8080 [You can get the ec2-instance-public-ip-address from your AWS EC2 console page]

Note: If you are not interested in allowing All Traffic to your EC2 instance 1. Delete the inbound traffic rule for your instance 2. Edit the inbound traffic rule to only allow custom TCP port 8080

After you login to Jenkins, - Run the command to copy the Jenkins Admin Password - sudo cat /var/lib/jenkins/secrets/initialAdminPassword - Enter the Administrator password

![14](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/12623de8-73f7-4d7b-9b96-bd31b8413fef)
![16](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/8fc7a6ac-6c86-462c-b56f-2bcae7b4ab11)
![17](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/44bb59b3-93c1-4f70-a67a-3a430111b1a5)
![18](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/882029ae-4cdf-4765-b2ce-229d273f9966)

## Install the Docker Pipeline plugin in Jenkins:
- Log in to Jenkins.
- Go to Manage Jenkins > Manage Plugins.
- In the Available tab, search for "Docker Pipeline".
- Select the plugin and click the Install button.
- Restart Jenkins after the plugin is installed.

![ss](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/247730c7-c997-4c19-b2ac-0f47bcac317e)
![plus](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/200b1e56-36e7-4a4e-b7f8-fc9f65015076)
![dockerplugin](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/456ee9b1-99c4-4d57-b01e-91a2a021bcfc)

## Install Docker with the following script.
```
#!/bin/bash

# Update package list
sudo apt-get update

# Install necessary packages to use HTTPS repositories
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository to sources list
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list for the addition to be recognized
sudo apt-get update

# Install Docker CE
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to the docker group to run Docker commands without sudo
sudo usermod -aG docker ${USER}

# Activate the changes to groups
su - ${USER}

# Verify Docker is installed and working
sudo systemctl status docker
```
![dockerinsall](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/98bda7b6-785e-46e5-8613-c292c82a8d16)
![docker status](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/dae44696-ba49-448b-9896-a0f57040877a)

## Grant Jenkins user permission to docker deamon.
```
sudo su - 
usermod -aG docker jenkins
systemctl restart docker
```
Once you are done with the above steps, it is better to restart Jenkins.
http://<ec2-instance-public-ip>:8080/restart

## create Directory and add python code for python application
```
mkdir hello-World-app
cd  hello-World-app
vi app.py
```
```
# This line imports the Flask class from the Flask framework, which is used to create web applications.
from flask import Flask

# built-in Python variable that represents the current module.
app = Flask(__name__)

# it specifies the root URL, which means that when you access the base URL
@app.route('/')

# This defines a Python function named hello
def hello():

# This line inside the hello function returns a simple string as the response to the client. 
    return "Hello, World! welcome to PearlThoughts. subscribe Now"

# ensures that the Flask app is only run if this script is the main entry point
if __name__ == '__main__':

enables debugging mod, The server will listen on port 8088 and all available network interfaces . 
    app.run(debug=True, host='0.0.0.0', port=8088)
```
![appcode](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/9761b771-6fde-4635-b49a-d08cba45e1e9)


