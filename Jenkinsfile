pipeline {
    agent any
    stages {
        stage('Plan') {
            steps {
	    	milestone(1)
	    	 withCredentials([[
    			$class: 'AmazonWebServicesCredentialsBinding',
    			credentialsId: "AWS IAM Admin",
    			accessKeyVariable: 'AWS_ACCESS_KEY_ID',
    			secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
			]]) { 
		    	sh 'terraform init -reconfigure'
		    	sh 'terraform plan -var-file=ecs.tfvars'
                }
            }
        }

	stage('Build Infrastructure'){
	    steps {
	   	input "Can we proceed with the infrastructure build ?"
	    	milestone(2)
		withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "AWS IAM Admin",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
                        sh 'terraform apply -auto-approve -var-file=ecs.tfvars'
		}

	    }
	}
        
    }
}
