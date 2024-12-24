##############################################
# Create ECR repositories for Docker images #
##############################################

# Define ECR repository for the application
resource "aws_ecr_repository" "app" {
  name = "recipe-app-api-app"

  # Allows reusing the same tag name for different image versions
  image_tag_mutability = "MUTABLE"

  # Force deletes the repository when running terraform destroy
  force_delete = true # Note: Avoid enabling this in production to prevent accidental deletion

  # Configuration for image vulnerability scanning
  image_scanning_configuration {
    scan_on_push = false # Disable for the course; enable (true) in real deployments for security.
  }
}

# Define ECR repository for the proxy
resource "aws_ecr_repository" "proxy" {
  name = "recipe-app-api-proxy"

  # Allows reusing the same tag name for different image versions
  image_tag_mutability = "MUTABLE"

  # Force deletes the repository when running terraform destroy
  force_delete = true # Note: Avoid enabling this in production to prevent accidental deletion

  # Configuration for image vulnerability scanning
  image_scanning_configuration {
    scan_on_push = false # Disable for the course; enable (true) in real deployments for security.
  }
}

# Notes:
# - Image scanning is disabled temporarily to ensure consistent versions during the course.
# - For production, enable scan_on_push for improved security.
# - Mutable tags are used to facilitate versioning during the course; consider setting to IMMUTABLE in production for stricter control.
