pipeline {
    agent any
    stages {
        stage('Prepare SSH Key') {
            steps {
                // Write the SSH public key from Jenkins credentials to a file in the workspace
                withCredentials([string(credentialsId: 'ssh_rsa_pub', variable: 'SSH_RSA_PUB')]) {
                    sh 'echo "$SSH_RSA_PUB" > ${WORKSPACE}/id_rsa.pub'
                }
            }
        }
        stage('AWS CLI Setup') {
            steps {
                // Use the AWS credentials for CLI commands
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                    sh '''
                        aws configure set default.region us-east-1
                        aws configure set default.output json
                        aws sts get-caller-identity
                    '''
                }
            }
        }
        stage('Checkout Code') {
            steps {
                // Checkout code from Git
                git url: 'https://github.com/DimRev/devops-multitier-app-terraform.git', branch: 'main'
            }
        }
        stage('Terraform Init') {
            steps {
                // Use the AWS credentials for Terraform operations with no color output and pass the correct public_key_path variable
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                    sh 'terraform init --upgrade -no-color -var "public_key_path=${WORKSPACE}/id_rsa.pub"'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                // Run Terraform plan with no color output and pass the correct public_key_path variable
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                    sh 'terraform plan -no-color -var "public_key_path=${WORKSPACE}/id_rsa.pub"'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                // Request user input before applying changes
                input message: 'Do you want to apply the Terraform changes?'
                // Apply changes if approved
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                    sh 'terraform apply -auto-approve -no-color -var "public_key_path=${WORKSPACE}/id_rsa.pub"'
                }
            }
        }
    }
    post {
        always {
            // Clean up the SSH key file regardless of the pipeline result
            sh 'rm -f ${WORKSPACE}/id_rsa.pub'
        }
        success {
            echo "Terraform pipeline succeeded."
        }
        failure {
            echo "Terraform pipeline failed."
        }
    }
}
