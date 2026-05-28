pipeline{
agent any
  
  environment {
    APP_NAME='myapp'
    VERSION='1.0.0'
}
stages{
  stage('checkout'){
       steps{
        echo 'pill code from github...'
        git branch: 'main',
          url: 'https://github.com/subalakshmir087-dataqueen/devops-practice.git.'
           }
}
stage('health check'){
     steps{
   echo 'running health check...'
   sh 'chmod +x scripts/health-check.sh'
   sh './scripts/health-check.sh'
          }
}
post{
   success{
    echo 'pipeline completed successfully!!'
}
failure{
   echo 'pipeline failed!!!'
}
}
}


