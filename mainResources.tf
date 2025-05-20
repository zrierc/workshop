resource "aws_s3_bucket" "workshop-terraform" {
  bucket = "workshop-bucket-smkn1jakarta-25"

  tags = {
    Name        = "Bucket Workshop SMKN 1 Jakarta"
    Environment = var.app_env
    Project     = var.project_name
  }
}
