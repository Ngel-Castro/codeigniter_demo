pipeline {
    agent any

    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
    }
    stages {
        stage('wainting for approval') {
            steps {
                echo 'sleep 180'
            }
        }
       
    stages {
        stage('Unit testing') {
            steps {
                echo 'new unit testing'
            }
        }
    }
}
