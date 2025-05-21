pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'https://hub.docker.com/repository/docker/mohamedjomaa1'  // Change to your registry
        DOCKER_USER='mohamedjomaa1'
        DOCKER_PASS=''
        BACKEND_IMAGE = 'investia-backend'
        SONAR_PROJECT_KEY = 'jenkins-cicd'
        SONAR_HOST_URL = 'http://localhost:9000'
        SONAR_TOKEN = credentials('sonartoken')
        DOCKER_TAG = 'latest'
        REMOTE_USER = "ec2-user"
        REMOTE_HOST = "3.88.166.52"
        REMOTE_DIR  = "/home/ec2-user/devops"
    }
    tools{
        maven 'maven'
       
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url:'https://github.com/mohamedjomaa1/Investia-devops.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    //withSonarQubeEnv('SonarQube') {
                       dir('investia-backend'){
                        //sh 'mvn compile'
                        //sh 'mvn test'
                        sh 'mvn sonar:sonar -Dsonar.projectKey=$SONAR_PROJECT_KEY -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_TOKEN'
                        }
                    //}
                }
            }
        } */
        
        stage('Unit Tests') {
            steps {
                dir('investia-backend') {
                    sh 'mvn test'
                }
            }
        } 
        
  
        
         stage('Build Docker Images') {
            steps {
                
                dir('investia-backend') {
                    sh "docker build -t ${BACKEND_IMAGE}:${DOCKER_TAG} ."
                }
                
            }
        }
       
        stage('Push to Docker Hub') {
            steps {
                script{
                   sh ' echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin'

                   sh 'docker tag ${BACKEND_IMAGE}:${DOCKER_TAG} mohamedjomaa1/investia-backend'
                   sh ' docker push mohamedjomaa1/investia-backend'
                   
                   
                    }
            }
        }
        

       stage('Deploy with Docker Compose') {
            steps {
                script{
                    sshagent(credentials:['ssh-secret']) {
                         sh """
                        ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} << EOF
                            cd ${REMOTE_DIR}
                            docker-compose pull
                            docker-compose up -d --remove-orphans
                            docker system prune   
                            EOF 
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}