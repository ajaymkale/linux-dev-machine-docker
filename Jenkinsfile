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
                checkout scm
            }
        }

        stage('Build Docker Image') {

            steps {

                sh '''
                docker build \
                -t ${IMAGE_NAME}:${IMAGE_TAG} \
                -t ${IMAGE_NAME}:latest .
                '''

            }
        }


        stage('Docker Hub Login') {

            steps {

                withCredentials([
                    usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                    )
                ]) {

                    sh '''
                    echo $DOCKER_PASS | docker login \
                    -u $DOCKER_USER \
                    --password-stdin
                    '''

                }

            }
        }



        stage('Push Image') {

            steps {

                sh '''
                docker push ${IMAGE_NAME}:${IMAGE_TAG}
                docker push ${IMAGE_NAME}:latest
                '''

            }
        }


    }


    post {

        success {

            echo "Image pushed successfully"

        }

        failure {

            echo "Build failed"

        }

    }

}
