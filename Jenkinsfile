pipeline {
    agent {
        node {
            label 'maven'
        }
    }

    environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
    }

    stages {
        stage("Build") {
            steps {
                sh 'mvn clean deploy'
            }
        }

        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'

                    // Переменная объявлена внутри script {}
                    def registry = 'https://salas05.jfrog.io/artifactory'

                    def server = Artifactory.newServer(
                        url: registry,
                        credentialsId: "artifact-jfrog-cred"
                    )

                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"

                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "maven-salas-libs-release-local/{1}",
                                "flat": "false",
                                "props": "${properties}",
                                "exclusions": [ "*.sha1", "*.md5"]
                            }
                        ]
                    }"""

                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)

                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }
    }
}
