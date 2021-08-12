pipeline {
    agent any
    stages {
        stage('Build code into docker image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    app = docker.build("leatherman300/train-schedule")
                    app.inside {
                        sh 'echo $(curl localhost:8080)'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_leatherman300') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                   
                     }
                }
            }
        }
    }   
}
