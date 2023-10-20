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
$ vi jenkins.sh
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
$ vi docker.sh

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
$ sudo su - 
$ usermod -aG docker jenkins
$ systemctl restart docker
```
Once you are done with the above steps, it is better to restart Jenkins.
http://<ec2-instance-public-ip>:8080/restart

## create Directory and add python code for python application
```
$ mkdir hello-World-app
$ cd  hello-World-app
$ vi app.py
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

# enables debugging mod, The server will listen on port 8088 and all available network interfaces . 
    app.run(debug=True, host='0.0.0.0', port=8088)
```
![appcode](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/9761b771-6fde-4635-b49a-d08cba45e1e9)

## create requirements.txt file for specifying the dependencies for the project.
```
$ vi requirements.txt
Flask==2.0.1
Werkzeug==2.0.1
```

## Create Dockerfile
```
$ vi Dockerfile

#  This specifies the base image for the container, which is an Alpine Linux image with Python 3.9 pre-installed.
FROM python:3.9-alpine

# This sets the working directory inside the container to /app.
WORKDIR /app

# This copies the requirements.txt file from the host to the /app directory inside the container.
COPY requirements.txt .

# This creates a Python virtual environment in the /venv directory inside the container for isolating Python dependencies for your application.
RUN python -m venv /venv

# This sets the PATH environment variable to include the /venv/bin directory, which allows you to use the Python and pip commands from the virtual environment.
ENV PATH="/venv/bin:$PATH"

# This  upgrades pip and installs the Python packages listed in requirements.txt into the virtual environment. The --no-cache-dir option is used to avoid caching the downloaded package files in the container to reduce image size.
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

This copies the entire contents of the host directory to the current directory (/app) inside the container. 
COPY . .

This specifies the command to run when the container is started.
CMD ["python", "app.py"]

the container will listen on port 8088.
EXPOSE 8088
```
![dockerfile](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/a1625af8-b12c-4ecd-97dc-e0a5bde522ae)

## create docker-compose yml file used to manage multi-container Docker applications.
```
$ vi docker-compose.yml
# specifies the version of the Docker Compose file format being used.
version : "3.3"

# you define the services for  application, there's a single service named "web."
services :
  web :
# specifies the Docker image that will be used for the "web" service. 
     image : nikhilk814/hello-world-app:v1
# used to map ports from the host machine to the container. 
     ports :
         - "8088:8088"
```
![docker-compose](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/b298cb64-495e-42c4-8b09-5e462ef9d204)

## create Jenkinsfile for CICD Pipeline
```
$ vi Jenkinsfile

# defines the start of a Jenkins Pipeline.
pipeline {

# defines environment variables that will be used throughout the pipeline.
  environment {

# A variable storing the name of the Docker image to be built
    imagename = "nikhilk814/hello-world-app:v1"

# A variable storing the name of the Docker registry credential to be used
    registryCredential= 'dockerhub'

# An empty variable that will be assigned later to represent the Docker image.
    dockerImage = ''

  }
#  This specifies that the pipeline can run on any available agent
  agent any
# This block defines the various stages of the pipeline.
  stages {

# This stage checks out the source code from a GitHub repository using the Git plugin. 
    stage('Checkout SCM') {

      steps {

        git([url: 'https://github.com/nikhilk814/python_hello_world_app.git', branch: 'master', credentialsId: 'github'])
      }

    }

# In this stage, a Docker image is built using the docker.build command.
    stage('Building image') {

      steps{

        script {

          dockerImage = docker.build imagename
        }

      }

    }
# This stage deploys the Docker image and pushes it to a Docker registry. It uses the docker.withRegistry block to manage Docker credentials and push the image.
# The image is tagged with the Jenkins build number and "v1" before pushing it to the registry. 
    stage('Deploy and Push Image') {

      steps{

        script {

          docker.withRegistry( '', registryCredential ) {

            dockerImage.push("$BUILD_NUMBER")

             dockerImage.push('v1')

          }

        }

      }

    }
# This stage releases the application using Docker Compose. It stops any existing containers and brings up the new containers using the docker-compose down and docker-compose up -d commands.
    stage('Release') {

      steps{

         sh "docker-compose down && docker-compose up -d"

      }

    }

  }

}
```
![jenkins file](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/5bb84524-6e30-43e7-b334-b8af6f1fb057)

## push hello-worrld application code into remote github repository
### create github remote repository
![gitrepo](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/d2636442-34f1-4294-ba73-9b2d87624d82)


```
$ cd  hello-World-app
$ git init          # Initializes a new Git repository in the current directory.
$ git add Dockerfile  # Add docker file in the current directory to the staging area. 
$ git commit -m "add docker file"  # Commits the staged changes with a commit message.
$ git add Jenkinsfile
$ git commit -m "add jenkinsfile file"
$ git add requirements.txt
$ git commit -m "add requirements.txt file"
$ git add app.py
$ git commit -m "add app.py file"
$ git add docker-compose.yml
$ git commit -m "add docker-compose.yml file"
$ git status           # Displays the current status of your Git repository, showing which files have been modified, staged, or committed.
$ git branch -M master  # Renames the current branch to "master." This is typically done after the initial commit to set the default branch name.
$ git add remote origin https://github.com/nikhilk814/python_hello_world_app.git # used to set up a remote 
$ git push -u origin master #  Pushes your local "master" branch to the remote repository named "origin." The -u flag sets up, you can use git push without specifying the branch and remote.
```
![commit init](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/a8a092f0-e6d6-491a-960c-155ef300c479)
![docker commits](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/d616132c-5cdd-4839-be1a-d2884a4573a1)
![gitpush](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/00fd7312-3da0-4dea-a984-cded0b68f274)

**note for github password we have to create github personal access tokens**

![gittokem](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/a018545f-1688-4be5-ac4a-fe3879c7e53b)

![git token generation](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/54038b49-37fa-4797-80b5-d15215d5cbb3)
![gitremotefile](https://github.com/nikhilk814/python_hello_world_app/assets/116155594/6b02d917-9232-4665-9e83-bac521c3b6d6)






