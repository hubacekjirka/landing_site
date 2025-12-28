resource "aws_s3_bucket" "landing_page" {
  bucket = "jirka-landing-page-eu-central-1"
  tags = {
    Environment = "live"
  }
}

resource "aws_s3_bucket_versioning" "landing_page" {
  bucket = aws_s3_bucket.landing_page.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "landing_page" {
  bucket = aws_s3_bucket.landing_page.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "landing_page" {
  bucket = aws_s3_bucket.landing_page.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontAccess"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.landing_page.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.landing_page.arn
          }
        }
      },
      {
        Sid    = "AllowCloudFrontList"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.landing_page.arn
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.landing_page.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket" "landing_page_logs" {
  bucket = "jirka-landing-page-logs-eu-central-1"
  tags = {
    Environment = "live"
    Purpose     = "access-logs"
  }
}

resource "aws_s3_bucket_public_access_block" "landing_page_logs" {
  bucket = aws_s3_bucket.landing_page_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "landing_page_logs" {
  bucket = aws_s3_bucket.landing_page_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "landing_page_logs" {
  bucket = aws_s3_bucket.landing_page_logs.id
  acl    = "log-delivery-write"

  depends_on = [
    aws_s3_bucket_ownership_controls.landing_page_logs
  ]
}

resource "aws_s3_bucket_lifecycle_configuration" "landing_page_logs" {
  bucket = aws_s3_bucket.landing_page_logs.id

  rule {
    id     = "expire-cloudfront-logs-180d"
    status = "Enabled"

    filter {
      prefix = "cloudfront/"
    }

    expiration {
      days = 180
    }
  }
}
