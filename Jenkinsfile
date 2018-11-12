@Library('pipeline-library') _

pipeline {
  agent { label 'docker' }
  environment {
    TESTING_CONTAINER_NAME = meta.getContainerName()
  }
  stages {
    stage('Build Dev Container') {
      // all branches
      steps {
        sh "docker build -t openstax/varnish:dev ."
      }
    }
    stage('Publish Latest Release') {
      when {
        anyOf {
          branch 'master'
          buildingTag()
        }
      }
      steps {
        withDockerRegistry([credentialsId: 'docker-registry', url: '']) {
          sh "docker tag openstax/varnish:dev openstax/varnish:latest"
          sh "docker push openstax/varnish:latest"
        }
      }
    }
    stage('Publish Version Release') {
      when { buildingTag() }
      environment {
          release = meta.version()
      }
      steps {
        withDockerRegistry([credentialsId: 'docker-registry', url: '']) {
          sh "docker tag openstax/varnish:dev openstax/varnish:${release}"
          sh "docker push openstax/varnish:${release}"
        }
      }
    }
  }
}
