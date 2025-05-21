// Jenkinsfile (Declarative Pipeline) - Version MINIMALE : Checkout + Build Maven + Unit Tests

pipeline {
    agent any // Ou un agent spécifique avec Maven/Java installé

    // La variable DOCKER_IMAGE_NAME n'est plus nécessaire pour l'instant
    /*
    environment {
        DOCKER_IMAGE_NAME = "tonnomdutilisateur/investia-app"
    }
    */

    tools {
        maven 'MAVEN_HOME' // Nom de la configuration Maven dans "Global Tool Configuration" de Jenkins
        jdk 'JDK_17'       // Nom de la configuration JDK dans "Global Tool Configuration" de Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning the repository...'
                checkout scm
            }
        }

        stage('Setup Environment') {
            steps {
                echo "Using JDK: ${tool 'JDK_17'}"
                echo "Using Maven: ${tool 'MAVEN_HOME'}"
            }
        }

        // --- MODIFICATION ICI ---
        stage('Build with Maven (and Run Unit Tests)') { // Nom de l'étape mis à jour
            steps {
                echo 'Building the application and running unit tests (Maven)...' // Message mis à jour
                // La commande 'clean package' va :
                // 1. 'clean': Nettoyer les builds précédents.
                // 2. 'package': Compiler le code source, exécuter les tests unitaires (phase 'test' de Maven),
                //    puis empaqueter le code compilé (ex: en .jar ou .war).
                // L'option -U force la mise à jour des dépendances.
                // L'option -B active le mode batch (non interactif), recommandé pour la CI.
                // L'option -Dmaven.test.skip=true A ÉTÉ RETIRÉE pour que les tests s'exécutent.
                bat "\"${tool 'MAVEN_HOME'}\\bin\\mvn.cmd\" -U clean package -B"
            }
        }
        // --- FIN DE LA MODIFICATION ---

        // ÉTAPES DOCKER SUPPRIMÉES/COMMENTÉES (conservées comme dans l'original)
        /*
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
    }

    post {
        always {
            echo 'Pipeline finished.'
            cleanWs()
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