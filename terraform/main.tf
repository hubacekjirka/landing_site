locals {
  all_domain_names = concat([var.domain_name], var.domain_aliases)
}

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

resource "aws_cloudfront_origin_access_control" "landing_page" {
  name                              = "landing-page-oac"
  description                       = "Access control for private S3 origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_acm_certificate" "landing_page" {
  provider = aws.us_east_1

  domain_name               = var.domain_name
  subject_alternative_names = var.domain_aliases
  validation_method         = "DNS"

  tags = {
    Environment = "live"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "landing_page" {
  provider        = aws.us_east_1
  certificate_arn = aws_acm_certificate.landing_page.arn

  validation_record_fqdns = [
    for option in aws_acm_certificate.landing_page.domain_validation_options : option.resource_record_name
  ]
}

resource "aws_cloudfront_distribution" "landing_page" {
  enabled             = true
  aliases             = local.all_domain_names
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket.landing_page.bucket_regional_domain_name
    origin_id   = "s3-landing-page-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.landing_page.id

    s3_origin_config {
      origin_access_identity = ""
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-landing-page-origin"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 60
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.landing_page.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
