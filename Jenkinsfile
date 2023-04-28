pipeline {
    agent any

    environment {
        SERVER_USERNAME = "$credentials('server-username')"
        SERVER_SSH_KEY  = "$credentials('server-ssh-key')"
        SERVER_HOST     = '34.200.228.201'
        DOCKER_PASSWORD = "$credentials('docker-login')"
        datadog_api_key = "$credentials('datadog-api-key')"
    }

    stages {
        stage('git clone') {
            steps {
                script {
                    git branch: 'main', credentialsId: 'github-login', url: 'https://github.com/techstarterepublic-dev/jenkins-course.git'
                }
            }
        }
        stage('Deploy to Target Server') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'docker-login', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD'),
                    sshUserPrivateKey(credentialsId: 'server-ssh-key', keyFileVariable: 'SSH_KEY_FILE', usernameVariable: 'SERVER_USERNAME'),
                    string(credentialsId: 'datadog-api-key', variable: 'DATADOG_API_KEY')
                ]) {
                    sh """
                    scp -i ${SSH_KEY_FILE} -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/react-app-dev/scripts-docker/deploy-to-target.sh ${SERVER_USERNAME}@${SERVER_HOST}:/home/ubuntu/deployment-app/deploy-to-target.sh
                    ssh -i ${SSH_KEY_FILE} -o StrictHostKeyChecking=no ${SERVER_USERNAME}@${SERVER_HOST} "sudo chmod +x /home/ubuntu/deployment-app/deploy-to-target.sh; DOCKER_USERNAME=${DOCKER_USERNAME} DOCKER_PASSWORD=${DOCKER_PASSWORD} DATADOG_API_KEY=${DATADOG_API_KEY} /home/ubuntu/deployment-app/deploy-to-target.sh"
                    """
                }
            }
        }
    }
}
