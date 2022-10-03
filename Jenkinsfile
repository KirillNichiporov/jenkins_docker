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
        sh "docker run -i $registry:latest"
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
    stage('Deploy in pre-prod') {
      steps{
        script {
          sh "kubectl apply -f jenk21.yaml --namespace=pre-prod"
          sleep 4
          sh "kubectl get pods --namespace=pre=prod"
        }
      }
    }
    stage('Deploy in prod') {
      steps{
        script {
          catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE'){
            def depl = true
            try{
              input("Deploy in prod?")
            }
            catch(err){
              depl = false
            }
            try{
              if(depl){
                sh "kubectl apply -f jenk21.yaml"
                sleep 4
                sh "kubectl get pods --namespace=prod"
                sh "kubectl delete -f jenk21.yaml --namespace=pre-prod"
              }
            }
            catch(Exception err){
              error "Deployment filed"
            }
          }
        }
      }
    }  
  }
  post {
    success {
      slackSend (color: '#00FF00', message: "Deployment success: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
    }
    failure {
      slackSend (color: '#FF0000', message: "Deployment failed: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
    }
  }
}
