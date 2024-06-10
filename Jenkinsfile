pipeline {
    agent any
    environment {
        GIT_HASH = GIT_COMMIT.take(8)
        // Directory to store the Terraform state file
        TF_STATE_DIR = "${WORKSPACE}/terraform_state"
    }

    stages {

        stage('Prepare State Directory') {
            steps {
                script {
                    // Ensure the state directory exists
                    sh "mkdir -p ${env.TF_STATE_DIR}"
                }
            }
        }

        stage('tofu Init') {
            steps {
                // Change directory to 'tofu' and initialize tofu
                dir('platform/infra') {
                    sh """
                    tofu init -input=false -backend-config="path=${env.TF_STATE_DIR}/terraform.tfstate"
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
                    tofu plan -input=false -out=tfplan -state=${env.TF_STATE_DIR}/terraform.tfstate
                    """
                }
            }
        }

        stage('tofu Apply') {
            steps {
                // Change directory to 'tofu' and apply the planned changes
                dir('platform/infra') {
                    sh """
                    tofu apply -input=false -auto-approve tfplan -state=${env.TF_STATE_DIR}/terraform.tfstate
                    """
                }
            }
        }
    }

    post {
        // always {
        //     // Clean up workspace after the job is done
        //     cleanWs()
        // }
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
