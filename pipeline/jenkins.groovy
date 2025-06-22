pipeline {
    agent any

    environment {
        GITHUB_TOKEN=credentials('juliadziuba')
        REPO = 'https://github.com/JuliaDzyuba/kbot.git'
        BRANCH = 'main'
    }
    
    parameters {
        choice(
            name: 'OS',
            choices: ['linux', 'darwin', 'windows'],
            description: 'Target operating system'
        )
        choice(
            name: 'ARCH',
            choices: ['amd64', 'arm64'],
            description: 'Target architecture'
        )
        booleanParam(
            name: 'SKIP_TESTS',
            defaultValue: false,
            description: 'Skip running tests'
        )
        booleanParam(
            name: 'SKIP_LINT',
            defaultValue: false,
            description: 'Skip running linter'
        )
    }

    stages {

        stage('clone') {
            steps {
                echo 'Clone Repository'
                git branch: "${BRANCH}", url: "${REPO}"
            }
        }

        stage('Lint') {
            when { expression { !params.SKIP_LINT } }
            steps {
                sh 'make lint'
            }
        }

        stage('Test') {
            when { expression { !params.SKIP_TESTS } }
            steps {
                sh 'make test'
            }
        }

        stage('build') {
            steps {
                echo "Build for platform ${params.OS} on ${params.ARCH} started"
                sh "make ${params.OS} ${params.ARCH}"
            }
        }

        stage('image') {
            steps {
                echo "Image build started"
                sh "make image"
            }
        }

        stage('push') {
            steps {
                echo "Push image"
                sh "make push"
            }
        }
    }
}
