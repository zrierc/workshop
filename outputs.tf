output "s3_information_arn" {
  value       = aws_s3_bucket.workshop-terraform.arn
  description = "ARN of the S3 Bucket"
}

output "s3_information_id" {
  value       = aws_s3_bucket.workshop-terraform.id
  description = "ID of the S3 Bucket"
}

output "available_AZs" {
  value       = data.aws_availability_zones.available
  description = "available AZs within VPC"
}

output "NAT_public_IP" {
  value       = aws_nat_gateway.nat.public_ip
  description = "Public IP Address for NAT Gateway within VPC"
}

# output "academy_role" {
#   value       = data.aws_iam_role.iam_for_lambda
#   description = "Existing IAM Role from AWS Academy"
# }

# output "list_available_ami" {
#   value       = data.aws_ami.list_ami
#   description = "List available AMI in us-east-1"
# }
