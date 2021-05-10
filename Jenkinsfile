pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            when {
                branch 'main'
            }
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
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerRegistryCred') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('DeployToProduction') {
            when {
                branch 'main'
            }
            steps {
                input 'Deploy to Production?'
                milestone(1)
                withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        sh "sshpass -p '$USERPASS' ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \'docker pull slobodyanyuk/jenkins_voting_app:${env.BUILD_NUMBER}'"
                        try {
                            sh "sshpass -p '$USERPASS' ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker stop jenkins_voting_app\""
                            sh "sshpass -p '$USERPASS' ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker rm jenkins_voting_app\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker run --restart always --name jenkins_voting_app -p 8080:8080 -d slobodyanyuk/jenkins_voting_app:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }    
	stage('Push image') {
	    when {
                branch 'main'
            }
		steps{
                	docker.withRegistry("https://registry.hub.docker.com", "slobodyanyuk/jenkins_voting_app") {            
       			app.push("${env.BUILD_NUMBER}")            
       			app.push("latest")        
		}
	    }    	
	}
    }
}
