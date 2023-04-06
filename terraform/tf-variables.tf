variable "INSTANCE_DEVICE_NAME" {
  type    = string
  default = "/dev/xvdh"
}

variable "JENKINS_URL" {
  type    = string
  default = "https://pkg.jenkins.io/debian"
}

variable "JENKINS_PORT" {
  type    = number
  default = 8080
}

variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
}

variable "AWS_ACCESS_KEY_ID" {
  type = string
}

variable "JENKINS_ADMIN" {
  type    = string
  default = "Jenkins-token-05"
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "target_group_name" {
  type    = string
  default = "jenkins-dev-lb-target-group"
}

variable "port" {
  type    = number
  default = 8080
}

variable "protocol" {
  type    = string
  default = "HTTP"
}