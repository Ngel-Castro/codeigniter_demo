pipeline {
    agent {
        docker {
            image 'php:8.0-apache' // Use an appropriate PHP Docker image
            args '-v /var/lib/jenkins/workspace:/var/www/html' // Mount workspace to web root
        }
    }

    environment {
        CI_COMPOSER_CACHE = '/tmp/composer-cache'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-repository/codeigniter4-app.git' // Replace with your repository
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Install Composer
                    sh 'curl -sS https://getcomposer.org/installer | php'
                    sh 'php composer.phar install'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Run CodeIgniter tests
                    sh './vendor/bin/phpunit' // Assuming PHPUnit is set up for your project
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image for CodeIgniter app
                    sh 'docker build -t my-codeigniter-app .'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Deploy the Docker image (this is just an example, customize as needed)
                    sh '''
                    docker stop my-codeigniter-app || true
                    docker rm my-codeigniter-app || true
                    docker run -d -p 80:80 --name my-codeigniter-app my-codeigniter-app
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean workspace after build
        }
    }
}
