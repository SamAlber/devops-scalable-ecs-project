###################################################################
# Create IAM user and policies for Continuous Deploy (CD) account #
###################################################################

# Create an IAM user for the CD account
resource "aws_iam_user" "cd" {
    name = "recipe-app-api-cd"
}

# Create access keys for the IAM user
resource "aws_iam_access_key" "cd" { 
    user = aws_iam_user.cd.name 
}

# Notes:
# - This user is designed for machine-to-machine communication (e.g., GitHub Actions connecting to AWS).
# - It cannot use MFA or username/password since it's an API user.
# - The generated API key/Access key acts as a password for the service, allowing it to authenticate as this IAM user.
# - Keep the key secure as it grants access to your AWS account.
# - The generated key will be output when this Terraform code is applied.

#########################################################
# Policy for Terraform backend to S3 and DynamoDB access #
#########################################################

# Define the policy document for Terraform backend access
# Allows the CD account to access specific resources required for Terraform operations

data "aws_iam_policy_document" "tf_backend" {
  # Statement to allow listing a specific S3 bucket
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.tf_state_bucket}"]
  }

  # Explanation:
  # - Grants the minimal access needed for listing the specified bucket containing the Terraform state.
  # - Ensures the CD account can access and manage the Terraform state.

  # Statement to allow object operations within specific paths in the S3 bucket
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = [
      "arn:aws:s3:::${var.tf_state_bucket}/tf-state-deploy/*",
      "arn:aws:s3:::${var.tf_state_bucket}/tf-state-deploy-env/*"
    ]
  }

  # Statement to allow operations on a specific DynamoDB table
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/${var.tf_state_lock_table}"]
  }

  # Explanation:
  # - Grants access to the DynamoDB table for state locking (essential for Terraform operations).
  # - Allows describing the table and performing item-level operations as needed by Terraform.
}

# Create the IAM policy from the defined document
resource "aws_iam_policy" "tf_backend" {
  name        = "${aws_iam_user.cd.name}-tf-s3-dynamodb"
  description = "Allow user to use S3 and DynamoDB for TF backend resources"
  policy      = data.aws_iam_policy_document.tf_backend.json
}

# Attach the IAM policy to the user
resource "aws_iam_user_policy_attachment" "tf_backend" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.tf_backend.arn
}

# Additional Notes:
# - Data blocks do not create resources but instead generate reusable data (e.g., policy documents).
# - Using Terraform to generate the policy document provides better integration with variables and reduces the need for external JSON files.
# - Resource blocks create or manage resources in AWS when Terraform is applied.


#########################
# Policy for ECR Access #
#########################

# Define an IAM policy document for ECR permissions
data "aws_iam_policy_document" "ecr" {
  # Allow retrieving an authorization token to authenticate with ECR
  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"] # Applies globally, as token retrieval doesn't depend on specific resources
  }

  # Allow necessary actions for pushing Docker images to ECR repositories
  statement {
    effect = "Allow"
    actions = [
      "ecr:CompleteLayerUpload",      # Complete the upload of a layer
      "ecr:UploadLayerPart",          # Upload parts of an image layer
      "ecr:InitiateLayerUpload",      # Start uploading a new image layer
      "ecr:BatchCheckLayerAvailability", # Check if specific layers exist
      "ecr:PutImage"                  # Push a new Docker image
    ]
    resources = [
      aws_ecr_repository.app.arn,     # ARN of the app repository
      aws_ecr_repository.proxy.arn,   # ARN of the proxy repository
    ] # Restricts access to only the specified repositories for better security
  }
}

# Create an IAM policy based on the above document
resource "aws_iam_policy" "ecr" {
  name        = "${aws_iam_user.cd.name}-ecr" # Name the policy after the user for clarity
  description = "Allow user to manage ECR resources"
  policy      = data.aws_iam_policy_document.ecr.json # Attach the JSON from the policy document
}

# Attach the ECR policy to the specified IAM user
resource "aws_iam_user_policy_attachment" "ecr" {
  user       = aws_iam_user.cd.name # Name of the CD user
  policy_arn = aws_iam_policy.ecr.arn # ARN of the policy to attach
}
