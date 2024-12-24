variable "tf_state_bucket" {
  description = "Name of S3 bucket in AWS for storing TF state"
  default     = "terraform.tfstate-ecr-project-57ikuk"
}

variable "tf_state_lock_table" {
  description = "Name of DynamoDB table in AWS for storing TF Lock"
  default = "tfstate-locks-ecr-project-57ikuk"

}

variable "aws_region" {
  default = "us-east-1"
}

variable "contact_info" {
  description = "Contact name for tagging resources"
  default     = "sam.albershtein@gmail.com"
}

variable "project_info" {
  description = "Project name for tagging resources"
  default     = "recipe-api-api"
}
