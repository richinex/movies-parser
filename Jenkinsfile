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
        sh 'mkdir -p cover' // Create the cover directory if it does not exist
        sh 'go test -coverprofile=cover/cover.cov'
        sh 'go tool cover -html=cover/coverage.cov -o coverage.html'
    }
}


}
