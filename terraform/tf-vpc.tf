# Virtual Private Cloud Module
module "vpc" {
  source                  = "git::https://github.com/bootcampus-elitesolutionsit/terraform-vpc-module.git?ref=v2.0.0"
  name                    = "jenkins"
  security_group_name     = "jenkins-sg"
  description             = "security for infrastructure"
  cidr_block              = "10.0.0.0/16"
  enable_dns_support      = true
  instance_tenancy        = "default"
  public_subnets          = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets         = ["10.0.64.0/20", "10.0.32.0/20"]
  map_public_ip_on_launch = true
  azs                     = ["us-east-1a", "us-east-1b"]
  security_group_ingress = [{

    description = "Mariadb access from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0" # Keep this to allow ansible login the application vm
    },
    {
      description = "Mariadb access from VPC"
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0" # Keep this to allow ansible login the application vm
    },
    {

      description = "Mariadb access from VPC"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0" # Keep this to allow ansible login the application vm
    },
    {
      description     = "Mariadb access from VPC"
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      security_groups = aws_security_group.lb_sg.id
    },
    {
      description     = "Mariadb access from VPC"
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      security_groups = aws_security_group.lb_sg.id
    }
  ]
  security_group_egress = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }]
}

resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = module.vpc.vpc_id[0]

  ingress {
    description = "SSH access from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins access from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}