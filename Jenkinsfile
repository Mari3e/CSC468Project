pipeline {
    agent none 
    stages {
        stage ('Deploy') {
            agent {
                node {
                    label 'deploy'
                }
            }
            steps {
                sshagent(credentials: ['cloudlab']) {
                    sh 'scp -r -v -o StrictHostKeyChecking=no *.yaml declan@130.127.132.225:~/'
                    sh 'ssh -o StrictHostKeyChecking=no declan@130.127.132.225 kubectl apply -f /users/declan/redis.yaml -n jenkins'
                    sh 'ssh -o StrictHostKeyChecking=no declan@130.127.132.225 kubectl apply -f /users/declan/redis-service.yaml -n jenkins'                                        
                }
            }
        }
    }
}
