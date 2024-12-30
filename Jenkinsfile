pipeline {
    agent any

    environment {
        // Variables d'environnement
        DOCKER_IMAGE = 'fops4/ic-webapp:1.0'
        RELEASES_FILE = 'releases.txt'
    }

    stages {
        stage('Check Docker') {
            steps {
                script {
                    // Vérification des versions Docker et docker-compose
                    echo 'Checking Docker version...'
                    sh 'docker --version || exit 1'

                    echo 'Checking Docker Compose version...'
                    sh 'docker-compose --version || exit 1'

                    // Vérification de l'accès à Docker
                    echo 'Testing Docker connection...'
                    try {
                        sh 'docker info'
                        echo 'Docker connection successful.'
                    } catch (Exception e) {
                        error 'Docker connection failed: Check permissions to access the Docker daemon.'
                    }
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh "docker build -t ${DOCKER_IMAGE} . || exit 1"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying using Ansible...'
                    try {
                        // Vérifiez si le fichier deploy.yml existe
                        sh '[ -f deploy.yml ] || (echo "deploy.yml not found!" && exit 1)'
                        sh "ansible-playbook -i localhost, deploy.yml"
                    } catch (Exception e) {
                        error 'Deployment failed: Check your Ansible configuration.'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo 'Running tests...'
                    try {
                        // Test d'accès à l'application
                        sh "curl -f http://localhost:8080"
                        echo 'Application is up and running.'
                    } catch (Exception e) {
                        error 'Test failed: Application is not accessible.'
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    echo 'Cleaning up unused Docker resources...'
                    // Nettoyage des images Docker
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
            // Nettoyage supplémentaire si nécessaire
        }
    }
}
