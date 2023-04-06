locals {
  common_tags = {
    Company = "TSR"
    Owner   = "Elitesolutionsit"
    github  = "https://github.com/bootcampus-elitesolutionsit/terraform-course"
  }

  network_tags = {
    Company = "TSR"
    Owner   = "Elitesolutionsit"
    github  = "https://github.com/bootcampus-elitesolutionsit/terraform-course"
  }

  application_tags = {
    Company     = "TSR"
    Owner       = "Elitesolutionsit"
    github      = "https://github.com/bootcampus-elitesolutionsit/terraform-course"
    Application = "Jenkins"
  }

  bucket_name      = "jenkinsdevbucket"
  bucket_acl       = "private"
  certificate_name = "jenkins-certificate"
  domain_name      = "*.dev.techstarterepublic.com"
  hosted_zone_name = "techstarterepublic.com"
  record_name      = "jenkins-dev.techstarterepublic.com"
}
