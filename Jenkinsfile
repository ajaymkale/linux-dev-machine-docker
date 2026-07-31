pipeline {

    agent any

    environment {
        IMAGE_NAME = "kaleaja/linux-dev-machine"
        IMAGE_TAG = "${BUILD_NUMBER}"
        JAVA_HOME = "/usr/lib/jvm/java-21-openjdk-amd64"
        MAVEN_HOME = "/usr/share/apache-maven-3.9.16/"
        PATH = "${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${PATH}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out source code from GitHub"
                checkout scm
            }
        }

        stage('Backup Existing Image') {
            steps {
                echo "Creating backup of current latest image"
                sh '''
                docker pull ${IMAGE_NAME}:latest || true
                docker tag \
                ${IMAGE_NAME}:latest \
                ${IMAGE_NAME}:backup || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building new Docker image"
                sh '''
                docker build \
                -t ${IMAGE_NAME}:latest .
                '''
            }
        }

   stage('Docker Hub Login') {

            steps {
                 echo "Starting Docker Hub Login"       


                echo "Logging into Docker Hub"


                withCredentials([
                    usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {


                    sh '''
                    echo $DOCKER_PASS | docker login \
                    -u $DOCKER_USER \

                    echo "$DOCKER_PASS" | docker login \
                    -u "$DOCKER_USER" \
                    --password-stdin

                    '''

                }

            }

        }

        stage('Push Backup Image') {
            steps {
                echo "Pushing backup image to Docker Hub"
                sh '''
                docker push ${IMAGE_NAME}:backup || true
                '''
            }
        }

        stage('Push Latest Image') {
            steps {
                echo "Pushing latest image to Docker Hub"
                sh '''
                docker push ${IMAGE_NAME}:latest
                '''
            }
        }

    }

    post {

        success {
            echo "Docker image build and push completed successfully"
        }

        failure {
            echo "Docker image build or push failed"
        }

    }

}
