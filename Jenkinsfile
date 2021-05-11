pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    app = docker.build("slobodyanyuk/jenkins_voting_app")
                    app.inside {
                        sh 'echo $(curl $prod_ip:8080)'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry("","08621aad-cec2-4de5-ae96-794ec307a457") {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('DeployToProduction') {
            steps {
                input 'Deploy to Production?'
                milestone(1)
                withCredentials([usernamePassword(credentialsId: "e956abb7-90da-440a-8bd1-8d16c2435495", usernameVariable: "bristlbeak_jenkins", passwordVariable: "rootroot")]) {
                    script {
                        sh "sudo sshpass -p 'rootroot' ssh -o StrictHostKeyChecking=no bristlbeak@project1-0ubuntu \'sudo docker pull slobodyanyuk/jenkins_voting_app:${env.BUILD_NUMBER}'"
                        try {
                            sh "sudo sshpass -p 'rootroot' ssh -o StrictHostKeyChecking=no bristlbeak@project1-0ubuntu \"sudo docker stop jenkins_voting_app\""
                            sh "sudo sshpass -p 'rootroot' ssh -o StrictHostKeyChecking=no bristlbeak@project1-0ubuntu \"sudo docker rm jenkins_voting_app\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sudo sshpass -p 'rootroot' ssh -o StrictHostKeyChecking=no bristlbeak@project1-0ubuntu \"sudo docker run --restart always --name jenkins_voting_app -p 8080:8080 -d slobodyanyuk/jenkins_voting_app:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }    
    }
}
