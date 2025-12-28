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
