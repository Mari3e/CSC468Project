pipeline {
    agent none 
    environment {
        docker_user = "declanteofilakdocker"
    }
    stages {
        stage('Publish') {
            agent {
                kubernetes {
                    inheritFrom 'agent-template'
                }
            }
            steps{
                container('docker') {
                    sh 'echo $DOCKER_TOKEN | docker login --username $DOCKER_USER --password-stdin'
                    sh 'cd worker; docker build -t $DOCKER_USER/worker:$BUILD_NUMBER .'
                    sh 'docker push $DOCKER_USER/worker:$BUILD_NUMBER'
                }
            }
        }
        stage ('Deploy') {
            agent {
                node {
                    label 'deploy'
                }
            }
            steps {
                sshagent(credentials: ['cloudlab']) {
                    sh "sed -i 's/DOCKER_REGISTRY/${docker_user}/g' worker.yaml"
                    sh "sed -i 's/BUILD_NUMBER/${BUILD_NUMBER}/g' worker.yaml"
                    sh 'scp -r -v -o StrictHostKeyChecking=no *.yaml declan@130.127.132.241:~/'
                    sh 'ssh -o StrictHostKeyChecking=no declan@130.127.132.241 kubectl apply -f /users/declan/worker.yaml -n jenkins'
                }
            }
        }
    }
}
