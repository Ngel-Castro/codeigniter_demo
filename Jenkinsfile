pipeline {
    agent any
    environment {
    GIT_HASH = GIT_COMMIT.take(8)
    }

    stages {

        stage('tofu Init') {
            steps {
                // Change directory to 'tofu' and initialize tofu
                dir('platform/infra') {
                    sh """
                    tofu init
                    """
                }
            }
        }

        stage('tofu Plan') {
            steps {
                // Change directory to 'tofu' and plan the tofu changes
                dir('platform/infra') {
                    sh """
                    echo $GIT_HASH
                    tofu plan -out=tfplan
                    """
                }
            }
        }

        stage('tofu Apply') {
            steps {
                // Change directory to 'tofu' and apply the planned changes
                dir('platform/infra') {
                    sh """
                    tofu apply -auto-approve tfplan
                    """
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
