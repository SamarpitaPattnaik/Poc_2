pipeline {
   agent any
    tools {
    maven 'Maven3'
    jdk 'JDK17'
}
    environment {
    SONAR_TOKEN = credentials('sonar-token')
    IMAGE_NAME = "myapp"
    IMAGE_TAG = "${BUILD_NUMBER}"
}
    
   stages {
       stage('1. Clone Repository') {
           steps {
               echo 'Cloning the repository...'
               git branch: 'main',
                   url: 'https://github.com/username/repository-name.git'
           }
       }
       stage('2. Verify Files') {
           steps {
               sh 'ls -la'
               sh 'cat app.py'
           }
       }
       stage('3. Maven Build') {
        steps {
            sh '''
            export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
            export PATH=$JAVA_HOME/bin:$PATH
            mvn clean package -DskipTests
            '''
        }
    }
       stage('4. SonarQube') {
        steps {
            withSonarQubeEnv('SonarQube') {
                sh '''
                mvn sonar:sonar \
                -Dsonar.projectKey=myapp \
                -Dsonar.login=${SONAR_TOKEN}
                '''
            }
        }
    }

       stage('5. Docker Build') {
        steps {
            sh '''
            docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
            docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
            '''
        }
    }
       stage('6. Stop Old Container') {
           steps {
               echo 'Stopping old container if running...'
               sh 'docker stop hello-container || true'
               sh 'docker rm hello-container || true'
           }
       }
       stage('7. Run Container') {
           steps {
               echo 'Running container on port 5000...'
               sh 'docker run -d --name ${IMAGE_NAME} -p 5000:5000 ${IMAGE_NAME}:${IMAGE_TAG}'
           }
       }
   }
   post {
       success {
           echo '✅ App is live at 5000'
       }
       failure {
           echo '❌ Pipeline failed! Check logs.'
       }
   }
}
