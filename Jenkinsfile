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
        sh 'mkdir -p coverage' // Create the coverage directory on the Jenkins host
        imageTest.inside("-v ${env.WORKSPACE}/coverage:/go/src/github.com/richinex/movies-parser/coverage"){
            // Inside the Docker container, write the coverage files to the mounted Docker volume
            sh 'go test -coverprofile=coverage/coverage.cov'
            sh 'go tool cover -html=coverage/coverage.cov -o coverage/coverage.html'
        }
    }

    stage('Security Tests'){
        imageTest.inside('-u root:root'){
        sh 'nancy /go/src/github/richinex/movies-parser/Gopkg.lock'
        }
    }

    stage('Publish Coverage Report'){
        publishHTML(target: [
        allowMissing: false,
        alwaysLinkToLastBuild: false,
        keepAll: true,
        reportDir: 'coverage',
        reportFiles: 'coverage.html',
        reportName: 'Go Test Coverage'
        ])
    }

}