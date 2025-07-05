resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "todo-cloudtrail-logs-${random_id.suffix.hex}"
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "cloudtrail-logs"
  }
}

resource "aws_s3_bucket_acl" "cloudtrail_logs_acl" {
  bucket = aws_s3_bucket.cloudtrail_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.cloudtrail_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudtrail" "main" {
  name                          = "todo-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  tags = {
    Name = "todo-cloudtrail"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}
