pipeline {
    agent any

    stages {
        stage('Change Directory') {
            steps {
                // Change directory to 'tofu'
                dir('platform') {
                    stage('tofu Init') {
                        steps {
                            script {
                                // Initialize tofu
                                sh """
                                tofu init
                                """
                            }
                        }
                    }

                    stage('tofu Plan') {
                        steps {
                            script {
                                // tofu plan to check the changes
                                sh """
                                tofu plan -out=tfplan
                                """
                            }
                        }
                    }

                    stage('tofu Apply') {
                        steps {
                            script {
                                // Apply the planned changes
                                sh """
                                tofu apply -auto-approve tfplan
                                """
                            }
                        }
                    }
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
            echo 'tofu Apply successful!'
        }
        failure {
            // Actions to perform when the job fails
            echo 'tofu Apply failed!'
        }
    }
}
