pipeline {
    agent { docker { image 'gcc:9.1.0' } }
    stages {
        stage('build') {
            steps {
                sh 'gcc --v'
            }
        }
    }
}