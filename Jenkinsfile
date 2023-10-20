pipeline {

  environment {

    imagename = "nikhilk814/hello-world-app:v1"

    registryCredential= 'dockerhub'

    dockerImage = ''

  }

  agent any

  stages {

    stage('Checkout SCM') {

      steps {

        git([url: 'https://github.com/nikhilk814/python_hello_world_app.git', branch: 'master', credentialsId: 'github'])



      }

    }

    stage('Building image') {

      steps{

        script {

          dockerImage = docker.build imagename

        

        }

      }

    }

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

    stage('Release') {

      steps{

         sh "docker-compose down && docker-compose up -d"

         



      }

    }

  }

}
