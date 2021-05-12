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
        stage('Pull Docker Image'){
            steps{
                sctipt{
                    docker.withRegistry("","08621aad-cec2-4de5-ae96-794ec307a457") {
                        app.pull("${env.BUILD_NUMBER}")
                        app.pull("latest")
                    }
                }
            }
        }
    }
}
