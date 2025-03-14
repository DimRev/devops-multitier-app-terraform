pipeline {
    agent any
    stages {
        stage('AWS CLI Setup') {
            steps {
                // Use the AWS credentials for CLI commands
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                    sh '''
                        # Configure AWS CLI with desired region and output format
                        aws configure set default.region us-east-1
                        aws configure set default.output json

                        # Verify the AWS credentials by printing the caller identity
                        aws sts get-caller-identity
                    '''
                }
            }
        }
        stage('Checkout Code') {
            steps {
                // Checkout code from Git
                git url: 'https://github.com/DimRev/devops-multitier-app-terraform.git', branch: 'f-14/03/25-setup-jenkins-and-ci-cd'
            }
        }
        stage('Terraform Init') {
            steps {
                // Use the AWS credentials for Terraform operations with no color output
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                    sh 'terraform init --upgrade -no-color'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                // Run Terraform plan with no color output
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                    sh 'terraform plan -no-color'
                }
            }
        }
    }
    post {
        success {
            echo "Terraform pipeline succeeded."
        }
        failure {
            echo "Terraform pipeline failed."
        }
    }
}
