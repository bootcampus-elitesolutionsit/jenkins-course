pipeline {
    agent any

    environment {
        SERVER_USERNAME = "$credentials('server-username')"
        SERVER_SSH_KEY  = "$credentials('server-ssh-key')"
        SERVER_HOST     = '18.204.34.175'
        DOCKER_PASSWORD = "$credentials('docker-login')"
    }

    stages {
            stage('git clone') {
                steps {
                    script {
                        git branch: 'main', credentialsId: 'github-login', url: 'https://github.com/arerepadelouisbenagha/datadog-sidecar.git'
                    }
                }
            }
            stage('Deploy to Target Server') {
                steps {
                    withCredentials([
                        usernamePassword(credentialsId: 'docker-login', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD'),
                        sshUserPrivateKey(credentialsId: 'server-ssh-key', keyFileVariable: 'SSH_KEY_FILE', usernameVariable: 'SERVER_USERNAME')
                    ]) {
                    sh """
                        scp -i ${SSH_KEY_FILE} -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/datadog-sidecar/scripts/deploy-to-target.sh ${SERVER_USERNAME}@${SERVER_HOST}:/tmp/deploy-to-target.sh
                        ssh -i ${SSH_KEY_FILE} -o StrictHostKeyChecking=no ${SERVER_USERNAME}@${SERVER_HOST} "chmod +x /tmp/deploy-to-target.sh; DOCKER_USERNAME=${DOCKER_USERNAME} DOCKER_PASSWORD=${DOCKER_PASSWORD} /tmp/deploy-to-target.sh"
                    """
                    }
                }
            }
        }
}