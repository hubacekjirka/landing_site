output "website_url" {
  description = "Primary HTTPS endpoint for the landing page"
  value       = "https://${aws_cloudfront_distribution.landing_page.domain_name}"
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name to use for CNAME/ALIAS records"
  value       = aws_cloudfront_distribution.landing_page.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "Hosted zone ID for the CloudFront distribution (useful for DNS providers that support ALIAS records)"
  value       = aws_cloudfront_distribution.landing_page.hosted_zone_id
}

output "acm_dns_validation_records" {
  description = "DNS validation records required to issue the ACM certificate (add these in GoDaddy)"
  value = {
    for option in aws_acm_certificate.landing_page.domain_validation_options :
    option.domain_name => {
      name  = option.resource_record_name
      type  = option.resource_record_type
      value = option.resource_record_value
    }
  }
}
