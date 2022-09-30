def stagestatus = [:]

pipeline {
      environment {
    registry = "kirill123433353463/python_app"
    registryCredential = 'dockerhub'
  }
  agent any
  stages {
        stage('Cloning Git') {
      steps {
        git 'https://github.com/pluhin/docker_build.git'
      }
    }
    
    stage("Test Dockerfile with linter") {
      steps {
        script {
          try {
          echo "Linting Dockerfile..."
          sh 'hadolint --ignore DL3018 --ignore DL3013 --ignore DL3019 --ignore DL4003 Dockerfile > lint_report.txt'
          archiveArtifacts artifacts: 'lint_report.txt'
          } catch (Exception err) {
            stagestatus.dockerfile_lint = "Linting failure"
            error "Something wrong with Dockerfile"
          }
        }
      }
    }

    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER" , "."
          //dockerImage = docker.build registry + ":$BUILD_NUMBER" , "--network host ."
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

