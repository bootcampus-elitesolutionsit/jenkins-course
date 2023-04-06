locals {
  common_tags = {
    Company = "TSR"
    Owner   = "techstarterepublic"
    github  = "https://github.com/bootcampus-techstarterepublic/terraform-course"
  }

  network_tags = {
    Company = "TSR"
    Owner   = "techstarterepublic"
    github  = "https://github.com/bootcampus-techstarterepublic/terraform-course"
  }

  application_tags = {
    Company     = "TSR"
    Owner       = "techstarterepublic"
    github      = "https://github.com/bootcampus-techstarterepublic/terraform-course"
    Application = "tacos"
  }

  certificate_name = "elitesolutionsit.com"
  domain_name      = "*.elitesolutionsit.com"
  hosted_zone_name = "elitesolutionsit.com"
  record_name      = "jenkins-dev.elitesolutionsit.com"
}
