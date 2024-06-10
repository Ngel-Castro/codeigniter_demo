pipeline {
    agent any

    stages {
        stage('provision new infra') {
            steps {
                sh "tofu --version"
            }
        }
        stage('email for approvals') {
            steps {
                sh ' echo "Email for approvals"'
            }
        }
        stage('test') {
            steps {
                sh ' echo "something here" '
            }
        }
    }
}
