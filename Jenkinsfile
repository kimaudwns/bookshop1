pipeline {
    agent any
    
    tools {
        jdk 'jdk11'
        maven 'M3'
    }
    environment { 
        DOCKERHUB_CREDENTIALS = credentials('dockerCredentials')  // Docker Hub 자격 증명 ID
        REGION = "ap-northeast-2"  // AWS 리전
        AWS_CREDENTIAL_NAME = 'AWSCredentials'  // AWS 자격 증명 ID
    }

    stages {
        stage('Git Clone') {
            steps {
                echo 'Git Clone'
                git url: 'https://github.com/kimaudwns/BookShop.git',
                branch: 'main', credentialsId: 'gitToken'
            }
            post {
                success {
                    echo 'Success git clone step'
                }
                failure {
                    echo 'Fail git clone step'
                }
            }
        }
        
        stage('Maven Build') {
            steps {
                echo 'Maven Build'
                dir('bookShop01'){
                   sh 'mvn -Dmaven.test.failure.ignore=true package'
                }
            }

        }
        
        stage('Docker Image Build') {
            steps {
                echo 'Docker Image build'                
                dir("${env.WORKSPACE}") {
                    sh """
                    docker build -t kimaudwns/bookshop:$BUILD_NUMBER .
                    docker tag kimaudwns/bookshop:$BUILD_NUMBER kimaudwns/bookshop:latest
                    """
                }
            }
        }

        stage('Docker Login') {
            steps {
                // Docker Hub 로그인
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        
        stage('Docker Image Push') {
            steps {
                echo 'Docker Image Push'  
                sh "docker push kimaudwns/bookshop:latest"  // Docker 이미지 푸시
            }
        }
        
        stage('Cleaning up') { 
            steps { 
                // Jenkins 서버의 사용하지 않는 Docker 이미지 제거
                echo 'Cleaning up unused Docker images on Jenkins server'
                sh """
                docker rmi kimaudwns/bookshop:$BUILD_NUMBER
                """
                //docker rmi kimaudwns/bookshop:latest
                //"""
            }
        }
        
        stage('Deploy to Kubernetes') {
        steps {
                  echo 'Deploying to Kubernetes Cluster'
                  withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                  dir("${env.WORKSPACE}"){
                  sh '''
                  export PATH=$PATH:/usr/bin
                  kubectl set image deployment/spring-petclinic spring-petclinic=yangjunseok/spring-petclinic:$BUILD_NUMBER -n spring-petclinic --record
                  '''
                    } 
                }
           }
        }
    }
}
