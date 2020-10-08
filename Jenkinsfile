pipeline {
    environment {
        registry = "crisis513/flask-app"
        registryCredential = 'crisis513'
        dockerImage = ''
        releaseName = "flask-app"
        helmChartRepo = "flask-kubernetes-helm"
        //release_version = '${BUILD_NUMBER}'
        release_version = 'latest'
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
                    dockerImage = docker.build registry + ":${release_version}"
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
                sh "docker rmi $registry:${release_version}"
            }
        }
        stage('Deploy image to kubernetes') {
            steps {
                //====== 이미 설치된 chart 인지 검사 =============
			//String out = sh script: "helm ls -q --namespace ${namespace}", returnStdout: true
			//if(out.contains("${releaseName}")) isExist = true
                sh """
                    helm lint ${helmChartRepo}
                    helm upgrade ${releaseName} ${helmChartRepo}
                """
            }
        }
    }
}
