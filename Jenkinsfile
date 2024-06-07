pipeline {
    agent any

    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('waiting for approvals') {
            steps {
                sh "sleep 180"
            }
        }
        stage('hello') {
            steps {
                echo 'test'
            }
        }
    }
}
