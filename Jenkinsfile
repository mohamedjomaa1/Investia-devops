// Jenkinsfile (Declarative Pipeline) - Version MINIMALE : Checkout + Build Maven

pipeline {
    agent any // Ou un agent spécifique avec Maven/Java installé

    // La variable DOCKER_IMAGE_NAME n'est plus nécessaire pour l'instant
    
    environment {
        DOCKER_IMAGE_NAME = "mohamedjomaa1/investia-backend"
    }
    

    tools {
        maven 'MAVEN_HOME' // Nom de la configuration Maven dans "Global Tool Configuration" de Jenkins
        jdk 'JDK_17'       // Nom de la configuration JDK dans "Global Tool Configuration" de Jenkins
    }
    options {
        timestamps() // Add timestamps to console output
        ansiColor('xterm') // Enable colored output
        preserveStashes() // Preserve stashes for multi-stage builds
        buildDiscarder(logRotator(numToKeepStr: '10')) // Keep last 10 builds
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning the repository...'
                checkout scm
                bat 'dir'
            }
        }

        stage('Setup Environment') {
            steps {
                echo "Using JDK: ${tool 'JDK_17'}"
                echo "Using Maven: ${tool 'MAVEN_HOME'}"
                bat 'docker --version' // Debug: Verify Docker installation
            }
        }

 /*       stage('Build with Maven (Skipping All Tests)') {
            steps {
                echo 'Building the application (Maven) - Skipping test compilation and execution...'
                // Utilisation de -Dmaven.test.skip=true pour sauter la compilation ET l'exécution des tests
                // L'option -U force la mise à jour des dépendances
                bat "\"${tool 'MAVEN_HOME'}\\bin\\mvn.cmd\" -U clean package -Dmaven.test.skip=true -B"
            }
        }*/

        stage('Build with Maven') {
            steps {
                echo 'Building the application with Maven...'
                // Compile and package, including tests (remove -Dmaven.test.skip=true)
                bat "\"${tool 'MAVEN_HOME'}\\bin\\mvn.cmd\" -U clean package -B"
            }
        }


        // ÉTAPES DOCKER SUPPRIMÉES/COMMENTÉES
        
        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
                script {
                    def dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}", "--pull -f Dockerfile .")
                    if (env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'master') {
                        dockerImage.tag("${DOCKER_IMAGE_NAME}", "latest")
                    }
                }
            }
        }
/*
        stage('Push Docker Image') {
            steps {
                echo 'Push Docker Image stage - currently commented out'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploy stage - currently commented out'
            }
        }
        */
        stage('Unit Tests') {
            steps {
                dir('investia-backend') {
                    echo 'Running unit tests...'
                    bat "\"${tool 'MAVEN_HOME'}\\bin\\mvn.cmd\" test"
                }
            }
        }
}

    }

    post {
        always {
            echo 'Pipeline finished.'
            cleanWs() // Nettoie l'espace de travail Jenkins après le build
        }
        success {
            echo 'Pipeline successful!'
            // Notifier le succès (ex: mail, Slack)
        }
        failure {
            echo 'Pipeline failed.'
            // Notifier l'échec
        }
    }
}