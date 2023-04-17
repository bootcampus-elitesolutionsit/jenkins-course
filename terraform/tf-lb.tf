data "aws_route53_zone" "zone" {
  name         = local.hosted_zone_name
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  domain_name       = local.domain_name
  validation_method = "DNS"

  tags = merge({ Name = "elitesolutionsit.com", Env = "dev" }, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "records" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_lb" "loadbalancer" {
  name                       = lower(join("-", [local.application_tags.Application, "jenkins-dev-lb"]))
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [module.vpc.security_group_id, aws_security_group.lb_sg.id]
  subnets                    = [module.vpc.public_subnet_id[0], module.vpc.public_subnet_id[1]]
  enable_deletion_protection = false
  tags                       = merge({ Name = "jenkins-dev-lb", Env = "dev" }, var.tags, local.application_tags)
}

resource "aws_lb_target_group" "target_group" {
  name     = var.target_group_name
  port     = var.port
  protocol = var.protocol
  vpc_id   = module.vpc.vpc_id[0]

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = "5"
    unhealthy_threshold = "3"
    timeout             = "5"
    interval            = "30"
    matcher             = "200-299,403"
  }
}

resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.jenkins-instance.id
  port             = 8080
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:375866976303:certificate/66dd3ddc-416e-4ed7-a295-3056e2b989b3"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = local.record_name
  type    = "A"

  alias {
    name                   = aws_lb.loadbalancer.dns_name
    zone_id                = aws_lb.loadbalancer.zone_id
    evaluate_target_health = true
  }
}