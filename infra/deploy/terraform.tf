terraform { # Best Practice! 
  required_version = "1.9.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Specify the source for the AWS provider
      version = "= 5.76.0"      # Use a stable version of the AWS provider
    }
  }

    backend "s3" {
    bucket         = "terraform.tfstate-ecr-project-57ikuk"
    key            = "deploy/terraform.tfstate"
    workspace_key_prefix = "tf-state-deploy-env"
    /*
    With our deploy Terraform we're going to separate the state into separate workspaces using the Terraform
    Workspaces feature.
    So we'll have a workspace for the staging environment, a workspace for the production environment.

    And the way that it works is that AWS will separate these workspaces into separate locations within S3.

    And this allows us to specify the key for the environments in S3.

    So by default, it just I think it just uses something like dot env.

    We're specifying a key name here.

    And the reason why we're doing this, and the reason why we're specifying it for deploy, is because it will allow us to keep our fine grained permissions for our deploy user.

    So for our CD user we can say only allow it to use this specific key location in our S3 bucket.

    And then obviously the region is just the region that we're using.

    Encrypt is to enable encryption and DynamoDB table is for the state locking.

    And we're using the same for the setup and the deploy Terraform okay.
    */
    region         = "us-east-1"
    dynamodb_table = "tfstate-locks-ecr-project-57ikuk" # Optional, for state locking
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region # AWS provider configuration

  default_tags {
    tags = {
      Environment = terraform.workspace
      contact     = var.contact_info
      project     = var.project_info 
      ManageBy    = "Terraform/deploy"
    }
  }
}

locals {
    prefix = "${var.prefix}-${terraform.workspace}"
}

/*
allows us to get information from our AWS account.

So when we run the Terraform we'll be able to access the current region that we're using.

Which means we will no longer have to keep hard coding us east one.
*/
