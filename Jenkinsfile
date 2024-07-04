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
        REMOTE_HOME = "/home/administrator/"
        CONSUL_CREDENTIAL_ID = "consul-sa-token"
    }

    stages {

        stage('tofu Init') {
            steps {
                // Change directory to 'tofu' and initialize tofu
                dir('platform/infra') {
                    withCredentials([string(credentialsId: env.CONSUL_CREDENTIAL_ID, variable: 'CONSUL_HTTP_TOKEN')]) {
                        sh """
                        tofu init -backend-config="address=consul-prod.home:8500"
                        """
                    }
                }
            }
        }

        stage('tofu get IP') {
            steps {
                // Change directory to 'tofu' and apply the planned changes
                dir('platform/infra') {
                    withCredentials([
                        string(credentialsId: env.CONSUL_CREDENTIAL_ID, variable: 'CONSUL_HTTP_TOKEN')]) {
                    }
                    script {
                        // Execute a shell command and capture its output
                        withCredentials([string(credentialsId: env.CONSUL_CREDENTIAL_ID, variable: 'CONSUL_HTTP_TOKEN')]) {
                            def vm_ip = sh(script: 'tofu output -json vm-ip', returnStdout: true).trim()
                            env.VM_IP = vm_ip
                            echo "Output from shell command: ${env.VM_IP}"
                        }
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
                    echo "Deployment commit ${GIT_HASH} in to Web Server"
                    sudo mkdir -p /var/www/html/app/
                    sudo cp -R src/* /var/www/html/app/
                    sudo chown -R www-data:www-data /var/www/html/app
                    sudo chmod -R 755 /var/www/html/app
                    sudo mv app.conf /etc/apache2/sites-available/app.conf
                    rm -rf src/
                    sudo systemctl restart apache2
                    """
                }
            }
       }

        stage('Copy Script to Remote Server') {
            steps {
                sshagent([env.SSH_CREDENTIALS_ID]) {
                    sh """
                    scp -o StrictHostKeyChecking=no deployment_script.sh root@${env.VM_IP}:/tmp/
                    scp -o StrictHostKeyChecking=no app.conf root@${env.VM_IP}:${REMOTE_HOME}
                    scp -r  -o StrictHostKeyChecking=no src/ root@${env.VM_IP}:${REMOTE_HOME}
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
                        ssh -o StrictHostKeyChecking=no root@${env.VM_IP} 'bash /tmp/deployment_script.sh'
                        """
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
