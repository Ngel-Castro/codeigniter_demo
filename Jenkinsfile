pipeline {
    agent any
    environment {
        GIT_HASH = GIT_COMMIT.take(8)
        //GIT_HASH = "test-sever"
        // Directory to store the Terraform state file
        TF_STATE_DIR = "${WORKSPACE}/permament/terraform.tfstate"
        TFVARS="env/dev/tofu.tfvars"
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
                    tofu init
                    """
                }
            }
        }

        stage('tofu Plan') {
            steps {
                // Change directory to 'tofu' and plan the tofu changes
                dir('platform/infra') {
                    withCredentials([usernamePassword(credentialsId: 'PROXMOX_CREDENTIALS', usernameVariable: 'PROXMOX_TOKEN_ID', passwordVariable: 'PROXMOX_TOKEN_SECRET')]) {
                        sh """
                        tofu plan -out=tfplan -var-file=${env.TFVARS} -var="name=${env.GIT_HASH}" -var="proxmox_token_id=${PROXMOX_TOKEN_ID}" -var="proxmox_token_secret=${PROXMOX_TOKEN_SECRET}"
                        """
                    }
                }
            }
        }

        stage('tofu Apply') {
            steps {
                // Change directory to 'tofu' and apply the planned changes
                dir('platform/infra') {
                    withCredentials([usernamePassword(credentialsId: 'PROXMOX_CREDENTIALS', usernameVariable: 'PROXMOX_TOKEN_ID', passwordVariable: 'PROXMOX_TOKEN_SECRET')]) {
                        sh """
                        tofu apply -auto-approve -var-file=${env.TFVARS} -var="name=${env.GIT_HASH}" -var="proxmox_token_id=${PROXMOX_TOKEN_ID}" -var="proxmox_token_secret=${PROXMOX_TOKEN_SECRET}"
                        """
                    }
                    script {
                        // Execute a shell command and capture its output
                        def vm_ip = sh(script: 'tofu output -json vm-ip', returnStdout: true).trim()
                        env.VM_IP = vm_ip
                        echo "Output from shell command: ${env.VM_IP}"
                    }
                }
            }
        }

        stage('SSH to Development server') {
            steps {
                script {
                    // Connect to the remote server and execute command
                    sshagent(['ssh-key-credential']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no administrator@${env.VM_IP} 'git clone git@github.com:Ngel-Castro/codeigniter_demo.git -b main'
                        """
                    }
                }
            }
        }

        stage('running instance for couple of minutes') {
            steps {
                sh 'sleep 100'
            }
        }

        stage('tofu destroy') {
            steps {
                // Change directory to 'tofu' and apply the planned changes
                dir('platform/infra') {
                    withCredentials([usernamePassword(credentialsId: 'PROXMOX_CREDENTIALS', usernameVariable: 'PROXMOX_TOKEN_ID', passwordVariable: 'PROXMOX_TOKEN_SECRET')]) {
                        sh """
                        tofu destroy -auto-approve -var-file=${env.TFVARS} -var="name=${env.GIT_HASH}" -var="proxmox_token_id=${PROXMOX_TOKEN_ID}" -var="proxmox_token_secret=${PROXMOX_TOKEN_SECRET}"
                        """
                    }
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
