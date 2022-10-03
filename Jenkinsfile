pipeline {
      environment {
    registry = "kirill123433353463/python_app"
    registryCredential = 'dockerhub'
  }
      agent any //{label 'master'}
  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/KirillNichiporov/jenkins_docker.git'
      }
    }
    
    stage ("Lint dockerfile") {
        agent {
            docker {
                image 'hadolint/hadolint:latest-debian'
                label 'master'
                //image 'ghcr.io/hadolint/hadolint:latest-debian'
            }
        }
        steps {
            sh 'hadolint Dockerfile | tee -a hadolint_lint.txt'
        }
        post {
            always {
                archiveArtifacts 'hadolint_lint.txt'
            }
        }
    }

    stage('Building image') {
      steps{
        script {
          //dockerImage = docker.build("$registry:$BUILD_NUMBER")
          dockerImage = docker.build registry + ":latest" , "--network host ."
        }
      }
    }
    stage('Test image') {
      steps{
        sh "docker run -i $registry:$BUILD_NUMBER"
      }
    }
    
    stage('Push Image to repo') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    } 
  }
}
