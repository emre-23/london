node('jenkins-slave') {
    
     stage('test pipeline') {
        sh(script: """
            echo "hello"
           git clone https://github.com/emre-23/dallas.git
           
           docker build . -t test
        """)
    }
}