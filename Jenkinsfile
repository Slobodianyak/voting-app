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
                withCredentials([usernamePassword(credentialsId: "759aace3-3081-454d-8dd4-c05796039562", usernameVariable: "bristlbeak", passwordVariable: "rootroot")]) {
                    script {
                        sh "sshpass -e ssh -o StrictHostKeyChecking=no bristlbeak@project1-0ubuntu \'sudo docker pull slobodyanyuk/jenkins_voting_app:${env.BUILD_NUMBER}'"
                        try {
                            sh "sshpass -e ssh -o StrictHostKeyChecking=no bristlbeak@project1-0ubuntu \"sudo docker stop jenkins_voting_app\""
                            sh "sshpass -e ssh -o StrictHostKeyChecking=no bristlbeak@project1-0ubuntu \"sudo docker rm jenkins_voting_app\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -e ssh -o StrictHostKeyChecking=no bristlbeak@project1-0ubuntu \"sudo docker run --restart always --name jenkins_voting_app -p 8080:8080 -d slobodyanyuk/jenkins_voting_app:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }    
    }
}
