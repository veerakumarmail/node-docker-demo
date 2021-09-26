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
        stage('ssh') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dff-qa', passwordVariable: 'password', usernameVariable: 'userName')]) {
                            script {
                                def remote = [:]
                                remote.allowAnyHosts = true
                                remote.name = "root"
                                remote.host = "node1.dfftech.com"
                                remote.user = userName
                                remote.password = password
                                sshCommand remote: remote, command: "docker ps -q --filter name=demo-api | xargs -r docker kill"
                                sshCommand remote: remote, command: "docker ps -a -q --filter name=demo-api | xargs -r docker rm"
                                sshCommand remote: remote, command: "docker pull veerakumarmail/docker-node-sample:$BUILD_NUMBER"
                                sshCommand remote: remote, command: "docker run -d -p 6001:5000 --name=demo-api -e ENV_demo_DB=$ENV_DEMO_DB veerakumarmail/docker-node-sample:$BUILD_NUMBER"
                            }


                }

            }
        }

    }
}

