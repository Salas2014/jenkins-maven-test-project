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

                    def registry = 'https://salas05.jfrog.io/artifactory'
                    def server = Artifactory.newServer(
                        url: registry,
                        credentialsId: "artifact-jfrog-cred"
                    )

                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"

                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "*.jar",
                                "target": "mavaen-salas-libs-release-local",
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

        stage("Docker Build") {
            steps {
                script {
                    def imageName = 'salas05.jfrog.io/salas-project-docker-local/my-custom-image'
                    def version   = '2.1.2'

                    echo '<--------------- Docker Build Started --------------->'
                    def app = docker.build(imageName + ":" + version)
                    echo '<--------------- Docker Build Ended --------------->'
                }
            }
        }

        stage("Docker Publish") {
            steps {
                script {
                    echo '<--------------- Docker Publish Started --------------->'
                    def registry = 'https://salas05.jfrog.io/artifactory'
                    docker.withRegistry(registry, 'artifact-jfrog-cred') {
                        app.push()
                    }
                    echo '<--------------- Docker Publish Ended --------------->'
                }
            }
        }
    }
}
