resource "aws_instance" "jenkins-instance" {
  ami                    = "ami-007855ac798b5175e" #data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  subnet_id              = module.vpc.public_subnet_id[0]
  vpc_security_group_ids = [module.vpc.security_group_id, aws_security_group.lb_sg.id]
  key_name               = aws_key_pair.mykeypair.key_name
  user_data              = data.cloudinit_config.jenkins.rendered
  iam_instance_profile   = aws_iam_instance_profile.jenkins-role.name

  tags = {
    Name = "jenkins-vm"
  }
}

resource "aws_ebs_volume" "jenkins-data" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "jenkins-master"
  }
}

resource "aws_volume_attachment" "jenkins-data-attachment" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = aws_ebs_volume.jenkins-data.id
  instance_id  = aws_instance.jenkins-instance.id
  skip_destroy = true
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC94XyyjaWwt+ENYjs8Dh0omCTOXdFXDRdnZ6eRYfGdKj2Y7LQPSYw8kMzm5hf/aN3qg0RPcGpgPK7db4FbSvIWeNugRhuIbD7sWsktBJNZ95ntPrz0uT+f2S9W/QX+SPbByeNyXko1KAM0sfLvXLrAzOba5z+AyRQiBMO38TnStUuDX2WhUEG/99UW/U04kxvv+VtNMdQkMlrnVwcbcRldzkIU6A5tX0elZHZ1+/aGlwBkGHZBwXJYUdfuuTaTb6n+C+P9Ers/Uxi0T5rqJTVE46u+TIct/W0Z+ZicjoT42nUtwLe1+lBvXqgr2ag3HYyhpigadh3dgmd9or3OXPGu85fgcNreLwl767lA8OjfYFu3YgW2nMjNuIZfc90Mv7H1vbltv3yynLwXtIyBwYE8FK0mFC4P4t4ze2iGzFzkVFgJgzMiMsGDmVzKcgBqI6zicbYlxPXY9vYkOcGjYM83lLPntsvJaTWpSCG8iinroFwD/PR2IPVchi5VhJHMvt8= arere@TSR"
  lifecycle {
    ignore_changes = [public_key]
  }
}

# Application server
resource "aws_instance" "web-instance" {
  ami                    = "ami-007855ac798b5175e" #data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnet_id[0]
  vpc_security_group_ids = [module.vpc.security_group_id]
  key_name               = aws_key_pair.mykeypair.key_name
  user_data              = data.cloudinit_config.docker.rendered

  tags = {
    Name = "app-vm"
  }
}
