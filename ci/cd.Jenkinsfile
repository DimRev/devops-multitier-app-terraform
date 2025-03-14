pipeline {
    agent any
    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/DimRev/devops-multitier-app-terraform.git', branch: 'main'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init --upgrade'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
    post {
        success {
            echo "Terraform apply succeeded"
        }
        failure {
            echo "Terraform apply failed"
        }
    }
}
