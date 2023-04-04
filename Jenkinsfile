pipeline {
  environment {
    imagename = "devops"
    ecrurl = "https://837771900128.dkr.ecr.us-east-1.amazonaws.com"
    ecrcredentials = "ecr:us-east-1:aws-creds"
    dockerImage = ''
  } 
  agent any
  stages {
    stage('Cloning Git') {
      steps {
              sh "git clone https://github.com/sahat/hackathon-starter.git"

      }
    }
    stage('Building image') {
      steps{
        script {
           dir("hackathon-starter"){
          dockerImage = docker.build imagename
           }
        }
      }
    }
   
stage('Deploy Master Image') {
      steps{
        script {
          docker.withRegistry(ecrurl, ecrcredentials) {     
            dockerImage.push("$BUILD_NUMBER")
             dockerImage.push('latest')

          }
        }
      }
    }
stage('Trivy Scan') {
            steps {
                script {
                    sh """trivy image --exit-code 0 --severity CRITICAL --scanners vuln 837771900128.dkr.ecr.us-east-1.amazonaws.com/${imagename}:${BUILD_NUMBER} """
                    
                }
                
            }
        }

 

  }

  post {
     always {
	  
       cleanWs()
         
       }
    }  
}
