pipeline {
   agent any
   environment {
       REPO_URL = 'https://github.com/SamarpitaPattnaik/Poc_2.git'
       BRANCH = 'main'
       IMAGE_NAME = 'hello-mypoc'
       CONTAINER_NAME = 'hello-container'
       APP_PORT = '5000'
       CREDS_ID = 'github-creds'
   }
   stages {
       stage('1. Clone Repository') {
           steps {
               echo 'Cloning the repository...'
               checkout([
                   $class: 'GitSCM',
                   branches: [[name: "*/${BRANCH}"]],
                   userRemoteConfigs: [[
                       url: "${REPO_URL}",
                       credentialsId: "${CREDS_ID}"
                   ]]
               ])
           }
       }
       stage('2. Verify Files') {
           steps {
               sh 'ls -la'
               sh 'cat app.py'
           }
       }
       stage('3. Build Docker Image') {
           steps {
               echo 'Building Docker image...'
               sh "docker build -t ${IMAGE_NAME} ."
           }
       }
       stage('4. Stop Old Container') {
           steps {
               echo 'Stopping old container if running...'
               sh "docker stop ${CONTAINER_NAME} || true"
               sh "docker rm ${CONTAINER_NAME} || true"
           }
       }
       stage('5. Run Container') {
           steps {
               echo 'Running container...'
               sh "docker run -d --name ${CONTAINER_NAME} -p ${APP_PORT}:${APP_PORT} ${IMAGE_NAME}"
           }
       }
   }
   post {
       success {
           script {
               def publicIp = sh(script: "curl -s http://169.254.169.254/latest/meta-data/public-ipv4", returnStdout: true).trim()
               echo "✅ App is live at http://${publicIp}:${APP_PORT}"
           }
       }
       failure {
           echo '❌ Pipeline failed! Check logs.'
       }
   }
}
