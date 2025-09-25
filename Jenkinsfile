pipeline {
    agent any

    // Parameters to select customer/env
    parameters {
        choice(name: 'OPCO', choices: ['fintech', 'zintech', 'fliptech', 'stackbomb'], description: 'Select OPCO')
        choice(name: 'COUNTRY', choices: ['india', 'us', 'Ireland', 'Kailasha'], description: 'Select country')
        choice(name: 'ENV', choices: ['dev', 'stage', 'prod', 'qa'], description: 'Select environment')
        string(name: 'BRANCH', defaultValue: 'main', description: 'Branch to build (optional)')
        booleanParam(name: 'APPLY', defaultValue: false, description: 'Check to run terraform apply after plan')
    }

    environment {
        AWS_REGION = 'ap-south-1'
        TF_VERSION = '1.8.0'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    if (params.BRANCH?.trim()) {
                        git branch: params.BRANCH,
                            url: 'https://github.com/ManishTraining/Terraform-github-workflow.git',
                            credentialsId: 'Terraform-github-workflow-github-token'                                      //need to update fine grained token for this github repo an dadd in jenkins
                    } else {
                        checkout scm
                    }
                }
            }
        }

        stage('Configure AWS') {
            steps {
                sh '''
                    echo "AWS region: $AWS_REGION"
                    aws sts get-caller-identity
                '''
            }
        }

        stage('Terraform Version') {
            steps {
                sh """
                    terraform version
                """
            }
        }

        stage('Terraform Init') {
            steps {
                sh """
                    terraform init -reconfigure -upgrade -input=false -no-color \
                    -backend-config "key=${params.OPCO}-${params.COUNTRY}/${params.ENV}/terraform.tfstate"
                """
            }
        }

        stage('Terraform Format') {
            steps {
                sh "terraform fmt -check"
            }
        }

        stage('Terraform Validate') {
            steps {
                sh "terraform validate"
            }
        }

        stage('Terraform Plan') {
            steps {
                sh """
                    terraform plan -out=tfplan -no-color -input=false \
                    -var-file=./tfvars/${params.OPCO}-${params.COUNTRY}/${params.ENV}.tfvars
                """
            }
        }

        // stage('Terraform Apply') {
        //     when {
        //         expression { return params.APPLY == true }
        //     }
        //     steps {
        //         input message: "Apply Terraform plan for ${params.OPCO}-${params.COUNTRY}-${params.ENV}?", ok: "Apply"
        //         sh "terraform apply -auto-approve tfplan"
        //     }
        // }
    }

    post {
        success {
            echo "Terraform pipeline completed successfully for ${params.OPCO}-${params.COUNTRY}-${params.ENV}"
        }
        failure {
            echo "Terraform pipeline failed!"
        }
    }
}
