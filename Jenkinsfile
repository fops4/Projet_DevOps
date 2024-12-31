pipeline {
    agent any

    environment {
        PATH = "/usr/bin:$PATH"
        DOCKER_IMAGE = 'fops4/ic-webapp:1.0'
        RELEASES_FILE = 'releases.txt'
    }

    stages {
        stage('Check Docker') {
            steps {
                script {
                    echo 'Checking Docker version...'
                    sh 'docker --version || { echo "Docker is not installed or not available. Please check your environment."; exit 1; }'

                    echo 'Checking Docker Compose version...'
                    sh 'docker-compose --version || { echo "Docker Compose is not installed. Please install it."; exit 1; }'

                    echo 'Testing Docker connection...'
                    sh 'docker info || { echo "Docker connection failed: Check permissions to access the Docker daemon."; exit 1; }'
                }
            }
        }

        stage('Check Ansible') {
            steps {
                script {
                    echo 'Checking Ansible installation...'
                    sh '''
                        if ! which ansible > /dev/null; then
                            echo "Ansible is not installed. Please install it using your package manager."
                            exit 1
                        fi
                    '''
                    sh 'ansible --version || { echo "Failed to verify Ansible version."; exit 1; }'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh "docker build -t ${DOCKER_IMAGE} . || { echo \"Docker build failed.\"; exit 1; }"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_PASSWORD')]) {
                    script {
                        echo 'Pushing Docker image to Docker Hub...'
                        sh '''
                            echo "$DOCKER_PASSWORD" | docker login -u fops4 --password-stdin
                            docker tag ${DOCKER_IMAGE} fops4/${DOCKER_IMAGE}
                            docker push fops4/${DOCKER_IMAGE} || { echo "Failed to push Docker image."; exit 1; }
                        '''
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying using Ansible...'
                    sh '[ -f deploy.yml ] || { echo "deploy.yml not found! Deployment aborted."; exit 1; }'
                    sh "ansible-playbook -i localhost, deploy.yml || { echo \"Ansible deployment failed.\"; exit 1; }"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo 'Running tests...'
                    sh "curl -f http://localhost:8481 || { echo \"Application is not accessible.\"; exit 1; }"
                    echo 'Application is up and running.'
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    echo 'Cleaning up unused Docker resources...'
                    sh "docker rmi ${DOCKER_IMAGE} || true"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
        always {
            echo 'Performing final cleanup...'
            sh 'docker system prune -f || true'
        }
    }
}
