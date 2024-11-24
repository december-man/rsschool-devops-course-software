pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: nodejs
            image: node:alpine
            command:
            - cat
            tty: true
        # add kaniko here  
        '''
    }
  }
  stages {
    stage('Clone') {
      steps {
        container('nodejs') {
          git branch: 'task_6', url: 'https://github.com/december-man/rsschool-devops-course-software.git'
        }
      }
    }
    stage('Install Dependencies') {
      steps {
        container('nodejs') {
          sh 'cd /home/jenkins/agent/workspace/aws_devops_t6/myapp && npm install'
        }
      }
    }
    stage('Run Tests') {
      steps {
        container('nodejs') {
          script {
            sh 'cd /home/jenkins/agent/workspace/aws_devops_t6/myapp && node app.js &'
            sleep 5
            try {
              sh 'cd /home/jenkins/agent/workspace/aws_devops_t6/myapp && npm test'
            } finally {
              sh 'pkill -f "node app.js" || true'
            }
          }
        }
      }
    }

    stage('Build Docker Image Using Kamiko and Push It to AWS ECR') {
      steps {
        container('kaniko') {
          sh ''
        }
      }
    }
  }

  post {
    always {
      container('kaniko') {
        sh ''
      }
    }
  }
}