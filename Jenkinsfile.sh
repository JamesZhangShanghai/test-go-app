pipeline {
    agent {
        label 'my-jenkins-slave-cluster'
    }

    stages {
        stage('Prepare') {
            steps {
                sh "echo 'Checking the testbed.'"
            }
        }
        stage('UnitTest') {
            steps {
                script {
                    //sh "sleep 6000"
                    sh "echo ${env.WORKSPACE}"
                    sh "echo ${env.BUILD_ID}"
                    sh "mkdir -p /home/workspace/${env.BUILD_TAG}"
                    sh "cp -rf ./* /home/workspace/${env.BUILD_TAG}/"
                    if( sh(script: 'docker run -e "GO111MODULE=on" -e "GOPROXY=https://goproxy.cn" --rm -v /home/workspace/${BUILD_TAG}:/go/src/gowebdemo -w /go/src/gowebdemo golang:1.14.0 /bin/sh -c "/go/src/gowebdemo/rununittest.sh"', returnStatus: true ) != 0 ){
                       currentBuild.result = 'FAILURE'
                    }
                }
                //junit './**/*.xml'
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
        stage('Helm deploy') {
            steps {
                sh 'sleep 30'
            }
        }
        stage('Report') {
            steps {
                publishHTML (target: [
                            allowMissing: true,
                            alwaysLinkToLastBuild: false,
                            keepAll: true,
                            reportDir: "/home/workspace/${env.BUILD_TAG}/report",
                            reportFiles: "coverage.html",
                            reportName: 'HTML Report',
                            reportTitles: 'Coverage Report'
                        ])
            }
        }
    }
    post {
        failure {
            mail bcc: '', body: "<b>gopro build failed</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset    : 'UTF-8', from: 'jenkins_james@126.com', mimeType: 'text/html', replyTo: '', subject: "ERROR CI: Project name -> ${env.JOB_NAME}", to: "jian.zhang@mavenir.com";
        }
        success {
            mail bcc: '', body: "<b>gopro build success</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: 'jenkins_james@126.com', mimeType: 'text/html', replyTo: '', subject: "SUCCESS CI: Project name -> ${env.JOB_NAME}", to: "jian.zhang@mavenir.com";
        }
        
    }
}
