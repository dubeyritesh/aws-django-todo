output "cloudtrail_bucket" {
  value = aws_s3_bucket.cloudtrail_logs.bucket
}
