pipeline {
    agent any
    
    tools {
        maven 'Maven3'
        jdk 'JDK21'
    }
    
    environment {
        SONAR_TOKEN = credentials('sonar-token')
        IMAGE_NAME = "myapp"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/SamarpitaPattnaik/Poc_2.git'
            }
        }

        stage('Maven Compile') {
            steps {
                sh 'mvn compile'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube - Code Quality') {
            steps {
                withSonarQubeEnv('SonarQube-Server') {
                    sh '''mvn sonar:sonar \
                        -Dsonar.projectKey=myapp \
                        -Dsonar.token=${SONAR_TOKEN}'''
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --format HTML', 
                                odcInstallation: 'OWASP-DC'
                dependencyCheckPublisher pattern: '**/dependency-check-report.html'
            }
        }

        stage('Maven Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Trivy - Image Scan') {
            steps {
                sh '''
                    trivy image \
                      --exit-code 0 \
                      --severity HIGH,CRITICAL \
                      --format table \
                      ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Deploy to Docker Container') {
            steps {
                sh '''
                    docker stop myapp || true
                    docker rm myapp || true
                    docker run -d \
                      --name myapp \
                      -p 8081:8080 \
                      ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
        }
    }
}
