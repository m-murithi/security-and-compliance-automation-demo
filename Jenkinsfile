pipeline {
    agent any
    
    environment {
        SONARQUBE_URL = 'http://sonarqube:9000'
        ZAP_URL = 'http://zap:8090'
    }
    
    stages {
        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/rimubytes/juice-shop.git'
            }
        }
        
        stage('Static Code Analysis - SonarQube') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'sonar-scanner'
                }
            }
        }
        
        stage('Run OWASP ZAP Security Scan') {
            steps {
                script {
                    // Trigger OWASP ZAP Scan using the ZAP API
                    sh 'curl -X GET "$ZAP_URL/json/core/scan/?url=http://juice-shop:3000"'
                }
            }
        }
        
        stage('Generate Reports') {
            steps {
                script {
                    sh 'cp /zap/reports/* /var/jenkins_home/workspace/reports/'
                }
            }
        }
    }
    
    post {
        always {
            archiveArtifacts artifacts: 'reports/*'
        }
    }
}
