#####################################################
# Outputs for IAM user credentials (Access Key & Secret) #
#####################################################

# Output the Access Key ID for the CD user
output "cd_user_access_key_id" { 
    description = "AWS key ID for CD user"
    value       = aws_iam_access_key.cd.id
}

# Output the Access Key Secret for the CD user (marked as sensitive)
output "cd_user_access_key_secret" {
    description = "Access key secret for CD user"
    value       = aws_iam_access_key.cd.secret
    sensitive   = true
}

#########################################
# Outputs for repository URLs #
#########################################
# Add output values to make repository URLs available for build job configurations

output "app_repository_url" {
  value = aws_ecr_repository.app.repository_url
  description = "URL of the ECR repository for the application."
}

output "proxy_repository_url" {
  value = aws_ecr_repository.proxy.repository_url
  description = "URL of the ECR repository for the proxy."
}
