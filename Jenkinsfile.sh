pipeline {
    agent {
        label 'my-jenkins-slave-cluster'
    }
    stages {
        stage('UnitTest') {
            steps {
 
                sh 'chmod 777 /home/jenkins/agent/workspace/pipeline-goapp/*'
                sh 'cd /home/jenkins/agent/workspace/pipeline-goapp/'
                sh './rununittest.sh'
                junit '*.xml'
                script {
                    if( currentBuild.result == 'FAILURE' ) {
                       sh(script: "echo unit test failed, please fix the errors.")
                       sh "exit 1"
                    }
                }
            }
        }
        stage('Build') {
            steps {
                sh './buildapp.sh'
            }
        }
        stage('Deploy') {
            steps {
                sh './deployapp.sh'
            }
        }
    }
    post {
        failure {
            mail bcc: '', body: "<b>gopro build failed</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset    : 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "ERROR CI: Project name -> ${env.JOB_NAME}", to: "your email address";
        }
        success {
            mail bcc: '', body: "<b>gopro build success</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "SUCCESS CI: Project name -> ${env.JOB_NAME}", to: "your email address";
        }
    }
}