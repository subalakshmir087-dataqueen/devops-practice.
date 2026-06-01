pipeline {
    agent any

    environment {
        APP_NAME = 'myapp'
    }

    parameters {
        string(
            name: 'VERSION',
            defaultValue: '1.0.0',
            description: 'Version to deploy'
        )
        choice(
            name: 'ENVIRONMENT',
            choices: ['staging', 'production'],
            description: 'Target environment'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Pulling code from GitHub...'
                git branch: 'main',
                    url: 'https://github.com/subalakshmir087-dataqueen/devops-practice.git'
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying ${APP_NAME}:${params.VERSION} to ${params.ENVIRONMENT}..."
                sh 'chmod +x scripts/deploy.sh'
                sh "./scripts/deploy.sh ${params.VERSION}"
            }
        }

        stage('Health Check') {
            steps {
                echo 'Running health check...'
                sh 'chmod +x scripts/health-check.sh'
                sh './scripts/health-check.sh'
            }
        }

        stage('Log Rotation') {
            steps {
                echo 'Running log rotation...'
                sh 'chmod +x scripts/log-rotation.sh'
                sh './scripts/log-rotation.sh'
            }
        }

        stage('Disk Cleanup') {
            steps {
                echo 'Running disk cleanup...'
                sh 'chmod +x scripts/disk-cleanup.sh'
                sh './scripts/disk-cleanup.sh'
            }
        }

    }

    post {
        success {
            echo "✅ ${APP_NAME}:${params.VERSION} deployed to ${params.ENVIRONMENT}!!"
        }
        failure {
            echo "❌ Pipeline failed!! Check logs!!"
        }
        always {
            echo "🧹 Pipeline finished!!"
        }
    }
}
