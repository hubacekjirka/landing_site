variable "region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "domain_name" {
  description = "Primary domain name that should serve the landing page"
  type        = string
  default     = "hubacek.xyz"
}

variable "domain_aliases" {
  description = "Additional domain names (SANs) that should point to the landing page"
  type        = list(string)
  default     = ["www.hubacek.xyz"]
}
