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
                    sh 'cd webui; docker build -t $DOCKER_USER/webui:$BUILD_NUMBER .'
                    sh 'docker push $DOCKER_USER/webui:$BUILD_NUMBER'
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
                    sh "sed -i 's/DOCKER_REGISTRY/${docker_user}/g' webui.yaml"
                    sh "sed -i 's/BUILD_NUMBER/${BUILD_NUMBER}/g' webui.yaml"
                    sh 'scp -r -v -o StrictHostKeyChecking=no *.yaml declan@130.127.132.225:~/'
                    sh 'ssh -o StrictHostKeyChecking=no declan@130.127.132.225 kubectl apply -f /users/lngo/webui.yaml -n jenkins'
                    sh 'ssh -o StrictHostKeyChecking=no declan@130.127.132.225 kubectl apply -f /users/lngo/webui-service.yaml -n jenkins'                                        
                }
            }
        }
    }
}
