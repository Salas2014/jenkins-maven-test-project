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

                    // Указываем правильный URL репозитория Artifactory
                    def registry = 'https://salas05.jfrog.io/artifactory/libs-release-local'

                    // Настройка сервера JFrog
                    def server = Artifactory.newServer(
                        url: registry,
                        credentialsId: "artifact-jfrog-cred"
                    )

                    // Добавляем метаданные
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"

                    // Корректный `uploadSpec` для загрузки артефактов
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/*.jar",
                                "target": "libs-release-local/",
                                "flat": "true",
                                "props": "${properties}",
                                "exclusions": [ "*.sha1", "*.md5"]
                            }
                        ]
                    }"""

                    // Загружаем артефакты в JFrog
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)

                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }
    }
}
