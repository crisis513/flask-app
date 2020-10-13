pipeline {
    environment {
        registry = "crisis513/flask-app"
        registryCredential = 'crisis513'
        dockerImage = ''
        releaseName = "flask-app"
        helmChartRepo = "flask-kubernetes-helm"
        //release_version = '${BUILD_NUMBER}'
        release_version = 'latest'
        SLACK_CHANNEL = '#send-slack-message-from-jenkins'
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
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Cleaning up') {
            when {
                branch 'master'
            }
            steps {
                sh "docker rmi $registry:${release_version}"
            }
        }
        stage('Deploy image to kubernetes') {
            when {
                branch 'master'
            }
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
    post { 
		success { 
			slackSend (channel: SLACK_CHANNEL, color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})") 
		} 
		failure { 
			slackSend (channel: SLACK_CHANNEL, color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})") 
		}
	} 
}