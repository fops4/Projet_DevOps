pipeline {
    agent any

    environment {
        // Définir les variables d'environnement si nécessaire
        DOCKER_IMAGE = 'ic-webapp:1.0'
        RELEASES_FILE = 'releases.txt'
    }

    stages {
        stage('Check Docker') {
            steps {
                sh 'docker --version'
                sh 'docker-compose --version'
            }
        }
        stage('Build') {
            steps {
                script {
                    echo 'Building Docker image...'
                    // Construire l'image Docker
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying using Ansible...'
                    // Exécuter le playbook Ansible
                    sh "ansible-playbook -i localhost, deploy.yml"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo 'Running tests...'
                    // Ajouter des tests ici
                    // Exemple simple de test
                    try {
                        sh "curl -f http://localhost:8080" // Tester l'accès à l'application
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
                    echo 'Cleaning up...'
                    // Optionnel : Nettoyer les images ou conteneurs non utilisés
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
            // Actions de nettoyage, par exemple, supprimer des conteneurs temporaires
        }
    }
}