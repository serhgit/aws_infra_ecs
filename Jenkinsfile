pipeline {
    agent any
    stages {
        stage('Build') { 
            steps {
	    	 withCredentials([[
    			$class: 'AmazonWebServicesCredentialsBinding',
    			credentialsId: "AWS IAM Admin",
    			accessKeyVariable: 'AWS_ACCESS_KEY_ID',
    			secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
			]]) { 
                  	sh 'echo ${AWS_ACCESS_KEY_ID}'
		    	sh 'terraform init'
		    	sh 'terraform apply -destroy -auto-approve -var-file=ecs.tfvars'
                }
            }
        }
        
    }
}
