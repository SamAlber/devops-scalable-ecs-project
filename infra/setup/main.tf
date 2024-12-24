# AWS Account Information
data "aws_caller_identity" "current" {}

# Random Suffix for Bucket Names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result
}
