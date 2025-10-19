output "website_url" {
  description = "The URL of the S3 static website"
  value       = "http://${aws_s3_bucket.landing_page.bucket}.s3-website-${var.region}.amazonaws.com"
}