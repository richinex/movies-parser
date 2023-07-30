def imageName = 'richinex/movies-parser'
node('workers'){
    stage('Checkout'){
        checkout scm
    }

    def imageTest= docker.build("${imageName}-test", "-f Dockerfile.test .")
    stage('Quality Tests'){
        imageTest.inside{
            sh 'golint'
        }
    }

    stage('Unit Tests'){
        imageTest.inside{
            sh 'mkdir -p coverage' // Create the coverage directory if it does not exist
            sh 'go test -coverprofile=coverage/coverage.cov'
            sh 'go tool cover -html=coverage/coverage.cov -o coverage.html'
        }
    }

}
