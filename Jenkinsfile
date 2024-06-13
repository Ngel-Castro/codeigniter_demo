pipeline {
    agent any
    environment {
        GIT_HASH = GIT_COMMIT.take(8)
        //GIT_HASH = "test-sever"
        // Directory to store the Terraform state file
        TF_STATE_DIR = "${WORKSPACE}/permament/terraform.tfstate"
        TFVARS="env/dev/tofu.tfvars"
        SSH_CREDENTIALS_ID = "ssh-key-credential"
        PROXMOX_CREDENITALS_ID = "proxmox-credentials"
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
                    withCredentials([usernamePassword(credentialsId: env.PROXMOX_CREDENITALS_ID, usernameVariable: 'PROXMOX_TOKEN_ID', passwordVariable: 'PROXMOX_TOKEN_SECRET')]) {
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
                    withCredentials([usernamePassword(credentialsId: env.PROXMOX_CREDENITALS_ID, usernameVariable: 'PROXMOX_TOKEN_ID', passwordVariable: 'PROXMOX_TOKEN_SECRET')]) {
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

       stage('Prepare Script') {
            steps {
                // Create a sample script file to be executed on the remote server
                script {
                    writeFile file: 'deployment_script.sh', text: """
                    #!/bin/bash
                    echo "Deployment commit in to Web Server"
                    git clone git@github.com:Ngel-Castro/codeigniter_demo.git -b feature/infra
                    sudo cp -R codeigniter_demo/src/* /var/www/html/app/
                    sudo chown -R www-data:www-data /var/www/html/app
                    sudo chmod -R 755 /var/www/html/app
                    sudo cp codeigniter_demo/app.conf /etc/apache2/sites-available/app.conf
                    rm -rf codeigniter_demo
                    sudo systemctl restart apache2
                    """
                }
            }
       }

        stage('Copy Script to Remote Server') {
            steps {
                sshagent([env.SSH_CREDENTIALS_ID]) {
                    sh """
                    scp -o StrictHostKeyChecking=no deployment_script.sh administrator@${env.VM_IP}:/tmp/
                    """
                }
            }
        }

        stage('SSH to Development server') {
            steps {
                script {
                    // Connect to the remote server and execute command
                    sshagent([env.SSH_CREDENTIALS_ID]) {
                        sh """
                        ssh -o StrictHostKeyChecking=no administrator@${env.VM_IP} 'bash /tmp/deployment_script.sh'
                        """
                    }
                }
            }
        }

        stage('running instance for couple of minutes') {
            steps {
                sh 'sleep 180'
            }
        }

        stage('tofu destroy') {
            steps {
                // Change directory to 'tofu' and apply the planned changes
                dir('platform/infra') {
                    withCredentials([usernamePassword(credentialsId: env.PROXMOX_CREDENITALS_ID, usernameVariable: 'PROXMOX_TOKEN_ID', passwordVariable: 'PROXMOX_TOKEN_SECRET')]) {
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
