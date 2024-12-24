terraform { # Best Practice! 
  required_version = "1.9.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Specify the source for the AWS provider
      version = "= 5.76.0"      # Use a stable version of the AWS provider
    }
  }
}

# required_providers objects can only contain "version", "source" and "configuration_aliases" attributes. To configure a provider, use a "provider" block.

provider "aws" {
  region = var.aws_region # AWS provider configuration

  default_tags {
    tags = {
      Environment = terraform.workspace
      contact     = var.contact_info
      project     = var.project_info 
      ManageBy    = "Terraform/setup"
    }
  }
}
