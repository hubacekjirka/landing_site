resource "aws_cloudfront_origin_access_control" "landing_page" {
  name                              = "landing-page-oac"
  description                       = "Access control for private S3 origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
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

  logging_config {
    bucket          = aws_s3_bucket.landing_page_logs.bucket_domain_name
    include_cookies = false
    prefix          = "cloudfront/"
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
