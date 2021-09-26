pipeline {
    agent any
    environment {
        CI = 'true'
    }
    stages {
        stage('build') {
            steps {
                sh 'echo Building ${BRANCH_NAME}...'
            }
        }
        stage('Deploy for main') {
            when {
                branch 'main'
            }
            steps {
                sh 'npm install'
                sh 'npm run build'
                sh 'docker build -t veerakumarmail/docker-node-sample:$BUILD_NUMBER .'
                withCredentials([usernamePassword(credentialsId: 'dff-docker', passwordVariable: 'password', usernameVariable: 'username')]) {
                    sh "docker login --username ${username} --password ${password}"
                    sh 'docker push veerakumarmail/docker-node-sample:$BUILD_NUMBER'
                }
            }
        }

    }
}

