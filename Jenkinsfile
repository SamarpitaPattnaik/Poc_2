pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonar-token')
        IMAGE_NAME = "myapp"
        IMAGE_TAG = "${BUILD_NUMBER}"
        CONTAINER_NAME = "myapp-container"
    }

    stages {

        stage('1. Clone Repository') {
            steps {
                echo 'Cloning the repository...'
                git branch: 'main',
                url: 'https://github.com/SamarpitaPattnaik/Poc_8.git'
            }
        }

        stage('2. Verify Files') {
            steps {
                echo 'Checking project files...'
                sh 'ls -la'
            }
        }

        stage('3. Install Dependencies') {
            steps {
                echo 'Installing Python dependencies...'
                sh '''
                python3 --version
                pip3 install -r requirements.txt || true
                '''
            }
        }

        stage('4. SonarQube Scan') {
            steps {
                echo 'Running SonarQube analysis...'
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    sonar-scanner \
                    -Dsonar.projectKey=myapp \
                    -Dsonar.sources=. \
                    -Dsonar.token=${SONAR_TOKEN}
                    '''
                }
            }
        }

        stage('5. Docker Build') {
            steps {
                echo 'Building Docker image...'
                sh '''
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('6. Trivy Scan') {
            steps {
                echo 'Scanning Docker image with Trivy...'
                sh '''
                trivy image ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('7. Stop Old Container') {
            steps {
                echo 'Stopping old container...'
                sh 'docker stop ${CONTAINER_NAME} || true'
                sh 'docker rm ${CONTAINER_NAME} || true'
            }
        }

        stage('8. Run Container') {
            steps {
                echo 'Running new container...'
                sh '''
                docker run -d \
                --name ${CONTAINER_NAME} \
                -p 5000:5000 \
                ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Application deployed successfully on port 5000'
        }
        failure {
            echo '❌ Pipeline failed! Check logs.'
        }
    }
}
