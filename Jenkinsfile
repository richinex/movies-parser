def imageName = 'richinex/movies-parser'
node('workers'){
    stage('Checkout'){
        checkout scm
    }

    def imageTest= docker.build("${imageName}-test", "-f Dockerfile.test .")
    stage('Pre-integration Tests'){
        parallel (
            'Quality Tests'{
                imageTest.inside{
                    sh 'golint'
                }
            },
            'Unit Tests'{
                sh 'mkdir -p coverage' // Create the coverage directory on the Jenkins host
                imageTest.inside("-v ${env.WORKSPACE}/coverage:/go/src/github.com/richinex/movies-parser/coverage"){
                    // Inside the Docker container, write the coverage files to the mounted Docker volume
                    sh 'go test -coverprofile=coverage/coverage.cov'
                    sh 'go tool cover -html=coverage/coverage.cov -o coverage/coverage.html'
                }
            },
            'Publish Coverage Report'{
                publishHTML(target: [
                allowMissing: false,
                alwaysLinkToLastBuild: false,
                keepAll: true,
                reportDir: 'coverage',
                reportFiles: 'coverage.html',
                reportName: 'Go Test Coverage'
                ])
            },
        )
    }
}
