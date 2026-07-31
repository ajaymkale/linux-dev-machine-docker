 pipeline {
    agent any

    environment {
        IMAGE_NAME =
"kaleaja/myapp"
        IMAGE_TAG = "${BUILD_NUMBER}"

        JAVA_HOME =
"/usr/lib/jvm/java-21-openjdk-amd64"
        MAVEN_HOME = "/usr/share/apache-maven-3.9.16/"
       
PATH = "${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${PATH}"
    }

    stages {

       
stage('Checkout') {
            steps {
                checkout scm
          
 }
        }

        stage('Build Maven') {
            steps {
              
 sh 'mvn clean package -DskipTests'
            }
        }

       
stage('Build Docker Image') {
            steps {
                sh '''
               
docker build \
                -t ${IMAGE_NAME}:${IMAGE_TAG} \
                -t
${IMAGE_NAME}:latest .
                '''
            }
        }


       
stage('Login Docker Hub') {
            steps {
                withCredentials([

                   usernamePassword(
                        credentialsId:
'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
       
                passwordVariable: 'DOCKER_PASS'
                    )
         
      ]) {
                    sh '''
                    echo "$DOCKER_PASS" |
docker login \
                    -u "$DOCKER_USER" \
                   
--password-stdin
                    '''
                }
            }
       
}


        stage('Push Docker Image') {
            steps {
                sh
'''
                docker push ${IMAGE_NAME}:${IMAGE_TAG}
                docker
push ${IMAGE_NAME}:latest
                '''
            }
        }


       
stage('Run Container') {
            steps {
                sh '''
             
  docker rm -f myapp || true

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
            echo "Docker image pushed successfully:
${IMAGE_NAME}:${IMAGE_TAG}"
        }

        failure {
            echo "Build or deployment
failed."
        }
    }
}
