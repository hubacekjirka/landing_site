locals {
  all_domain_names = concat([var.domain_name], var.domain_aliases)
}
