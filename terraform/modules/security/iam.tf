# Allow EC2 to assume the role
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name               = "todo-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# IAM Policy for S3 Access
resource "aws_iam_policy" "s3_access" {
  name   = "todo-s3-access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.static_bucket}",
          "arn:aws:s3:::${var.static_bucket}/*"
        ]
      }
    ]
  })
}

# Attach policy to EC2 Role
resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

# Create instance profile for ASG to attach
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "todo-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}
