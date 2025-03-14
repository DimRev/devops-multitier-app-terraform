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
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                    git url: 'https://github.com/DimRev/devops-multitier-app-terraform.git', branch: 'main'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                // Use the same AWS credentials for Terraform operations
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                    sh 'terraform init --upgrade'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                    // sh 'terraform apply -auto-approve'
                    sh 'terraform plan'
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
