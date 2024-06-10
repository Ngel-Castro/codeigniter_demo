pipeline {
    agent any

        stage('Change Directory') {
            steps {
                // Change directory to 'terraform'
                dir('platform') {
                    stage('OpenTofu Init') {
                        steps {
                            script {
                                // Initialize Terraform
                                sh """
                                tofu init
                                """
                            }
                        }
                    }

                    // stage('Terraform Plan') {
                    //     steps {
                    //         script {
                    //             // Terraform plan to check the changes
                    //             sh """
                    //             tofu plan -out=tfplan
                    //             """
                    //         }
                    //     }
                    // }

                    // stage('Terraform Apply') {
                    //     steps {
                    //         script {
                    //             // Apply the planned changes
                    //             sh """
                    //             terraform tofu -auto-approve tfplan
                    //             """
                    //         }
                    //     }
                    // }
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace after the job is done
            cleanWs()
        }
        success {
            // Actions to perform when the job succeeds
            echo 'Infrastructure Apply successful!'
        }
        failure {
            // Actions to perform when the job fails
            echo 'Infrastructure Apply failed!'
        }
    }
}

