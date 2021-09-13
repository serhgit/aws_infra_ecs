pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
	    	milestone(1)
	    	 withCredentials([[
    			$class: 'AmazonWebServicesCredentialsBinding',
    			credentialsId: "AWS IAM Admin",
    			accessKeyVariable: 'AWS_ACCESS_KEY_ID',
    			secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
			]]) { 
		    	sh 'terraform init -migrate-state'
		    	sh 'terraform apply -auto-approve -var-file=ecs.tfvars'
                }
            }
        }
        
    }
}
