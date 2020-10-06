pipeline {
    environment {
        registry = "crisis513/flask-app" 
        registryCredential = 'crisis513'
        dockerImage = ''
    }
    agent {
        label "jenkins-slave"
    }
    stages {
        stage('Cloning our Git') {
            steps {
                git 'http://34.64.153.88:8001/root/flask-app.git'
            }
        }
        stage('Building docker image') {
            steps {
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        stage('Deploy docker image') {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Cleaning up') {
            steps {
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
        stage('Deploy image to kubernetes') {
            steps {
                sh """
                    helm upgrade --install flask-app flask-kubernetes-helm
                """
            }
        }
    }
}

