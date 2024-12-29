pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    // Construire l'image Docker
                    sh 'docker-compose -f roles/odoo_role/templates/docker-compose.yml build'
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    // Tester la connectivité et les réponses HTTP
                    sh 'curl -I http://localhost:8069 || exit 1'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Déployer avec Ansible
                    ansiblePlaybook playbook: 'ansible/playbook.yml', inventory: 'ansible/inventory.ini'
                }
            }
        }
    }
}
