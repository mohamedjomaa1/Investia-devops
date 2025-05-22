// Jenkinsfile (Declarative Pipeline) - Version MINIMALE : Checkout + Build Maven

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

        stage('Build with Maven (Skipping All Tests)') {
            steps {
                echo 'Building the application (Maven) - Skipping test compilation and execution...'
                // Utilisation de -Dmaven.test.skip=true pour sauter la compilation ET l'exécution des tests
                // L'option -U force la mise à jour des dépendances
                bat "\"${tool 'MAVEN_HOME'}\\bin\\mvn.cmd\" -U clean package -Dmaven.test.skip=true -B"
            }
        }

       /* stage('Build Backend and Run Unit Tests') {
            steps {
                // IMPORTANT: Remplacez 'NOM_DE_VOTRE_MODULE_BACKEND'
                // par le chemin relatif vers le répertoire de votre module backend
                // (celui qui contient le pom.xml du backend).
                // Par exemple: 'my-project-backend' ou 'services/backend-service'
                dir('INVESTIA') {
                    echo "Switched to backend directory: $(pwd)" // Affiche le répertoire courant (Windows: use 'cd')
                    echo 'Building the backend application and running unit tests (Maven)...'

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
        } */

        // ÉTAPES DOCKER SUPPRIMÉES/COMMENTÉES
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