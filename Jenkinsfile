pipeline {
   agent any
   stages {
       stage('1. Clone Repository') {
           steps {
               echo 'Cloning the repository...'
               git branch: 'main'
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
               sh 'docker build -t hello-python .'
           }
       }
       stage('4. Stop Old Container') {
           steps {
               echo 'Stopping old container if running...'
               sh 'docker stop hello-container || true'
               sh 'docker rm hello-container || true'
           }
       }
       stage('5. Run Container') {
           steps {
               echo 'Running container on port 5000...'
               sh 'docker run -d --name hello-container -p 5000:5000 hello-python'
           }
       }
   }
   post {
       success {
           echo '✅ App is live at http://<ec2-public-ip>:5000'
       }
       failure {
           echo '❌ Pipeline failed! Check logs.'
       }
   }
}
