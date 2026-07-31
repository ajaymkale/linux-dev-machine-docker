pipeline {

    agent any

    environment {
        IMAGE_NAME = "kaleaja/linux-dev-machine"
        IMAGE_TAG = "${BUILD_NUMBER}"

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
