output "bucket_name" {
  value = aws_s3_bucket.static_bucket.bucket
}

output "bucket_domain_name" {
  value = aws_s3_bucket.static_bucket.bucket_regional_domain_name
}
