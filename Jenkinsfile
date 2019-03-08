pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
              retry(3) {
                sh c:
                  cd C:\Git-J\test
                  robot -t Test1 Suite1.txt
              }
                
            }
        }
    }
}
