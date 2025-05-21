environment {
    DOCKER_IMAGE = "investia-app:latest"
    DOCKER_REGISTRY = "mohamedjomaa1" // Replace with your registry, e.g., Docker Hub username
    DOCKER_CREDENTIALS_ID = "docker-credentials-id" // Jenkins credentials ID for Docker registry
}

stages {
    stage('Checkout') {
        steps {
            // Checkout code from the repository
            git branch: 'BACKEND-INTEGRATION', url: 'https://github.com/mohamedjomaa1/investia.git' // Replace with your repo URL
        }
    }

    stage('Build Maven') {
        steps {
            // Build the Spring Boot application with Maven
            sh 'mvn clean package -DskipTests'
        }
    }

    stage('Build Docker Image') {
        steps {
            // Build the Docker image
            sh "docker build -t ${DOCKER_IMAGE} ."
        }
    }

    stage('Push Docker Image') {
        steps {
            // Login to Docker registry and push the image
            withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin ${DOCKER_REGISTRY}"
                sh "docker tag ${DOCKER_IMAGE} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}"
                sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}"
            }
        }
    }

    stage('Deploy') {
        steps {
            // Deploy the application (e.g., to a Kubernetes cluster or Docker Compose)
            sh 'docker-compose -f docker-compose.yaml up -d'
        }
    }
}

post {
    always {
        // Clean up Docker images to save space
        sh "docker rmi ${DOCKER_IMAGE} || true"
        sh "docker rmi ${DOCKER_REGISTRY}/${DOCKER_IMAGE} || true"
    }
    success {
        echo 'Build and deployment successful!'
    }
    failure {
        echo 'Build or deployment failed.'
    }
}