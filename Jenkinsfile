pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                parallel(first: {
                  robot -t Test1 Suite1.txt
                },second: {
                    robot -t Test1 Suite1.txt
                })
              //retry(3) {
                //sh './Jenkinsfile.sh'
              //}
                
            }
        }
    }
}
