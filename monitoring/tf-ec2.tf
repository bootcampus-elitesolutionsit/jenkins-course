# Application server
resource "aws_instance" "jenkins_instance" {
  ami                    = "ami-007855ac798b5175e"
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnet_id[0]
  vpc_security_group_ids = [module.vpc.security_group_id]
  key_name               = aws_key_pair.jenkins_monitor_key.key_name
  user_data              = <<-EOF
                            #!/bin/bash
                            sudo apt-get -y update
                            sudo apt-get install -y openjdk-11-jdk
                            curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
                            /usr/share/keyrings/jenkins-keyring.asc > /dev/null
                            echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                            https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                            /etc/apt/sources.list.d/jenkins.list > /dev/null
                            sudo apt-get -y update
                            sudo apt-get -y install jenkins
                            EOF
  tags = {
    Name = "Jenkins-monitoring-lecture"
  }
}

resource "aws_key_pair" "jenkins_monitor_key" {
  key_name   = "jenkins-monitoring-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDbfj7TVUsk5rZzVX8dgd97qqSnJJQS7ou91rqNu2RDyH2Nc6v4krUJ6qKKKj4vH5oIC7Ej3iyTtMbvioAFS2uKCQKbbv5A9Qcu+pM9AoMWqTRxOxq6jLZqQi8D6bbLLWlIIsE8Y0Cz3MZePC+2qtWL9ZiLp6tKcf7LBeSIK71hCPik/rXVJnGjv1DE1R+bk00jyKXH2g8DzlSMHqie+AX63pMkcbeZCMqZ92v4/x2Rfg6Adxl/BfkWhxl6/jUr/IuiEPS9lJL7a0j+mX0bB296ouiUaXoF7odzO2amaByMubjioMctCCcgiajqRFuAL1GZu0LWtjDUEUDX+fFsoB6lT18eOsH63Ih0VBjhZ0l7gJOaWXvki7rnFGKJML6mbDOmeyvlquu/vbenFqcEfFygqiTvMMPA9jiE7SIMIfFA/Eh0TFSaAOqRXfOLxDvHSWvBuRw09yER1Pj4bhQPuxG0KGwNGILmwC3pAuJ+rLT6JG4WT086ljJg+piYJ8Qqmrk= arere@TSR"
}