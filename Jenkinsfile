pipeline {
    agent any
    environment {
        stage_ip = '3.83.229.172'
        }
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
        stage('DeployToStage') {
            when {
                branch 'master'
            }
            steps {
              //  input 'Deploy to Production?'
               // milestone(1)
                withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$stage_ip \"docker pull willbla/train-schedule:${env.BUILD_NUMBER}\""
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$stage_ip \"docker stop train-schedule\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$stage_ip \"docker rm train-schedule\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$stage_ip \"docker run --restart always --name train-schedule -p 8080:8080 -d leatherman300/train-schedule:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }

}
