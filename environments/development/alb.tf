resource "aws_security_group" "alb" {
  name   = "${var.sys_name}-sg-alb"
  vpc_id = module.network_base.vpc_id
  depends_on = [
    module.network_base,
  ]

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.sys_name}-sg-alb"
    Env  = var.env
  }
}

resource "aws_lb" "main" {
  load_balancer_type = "application"
  name               = "${var.sys_name}-alb"

  security_groups = [
    aws_security_group.alb.id,
  ]
  subnets = [
    module.public_subnet_a.id,
    module.public_subnet_c.id,
  ]
  depends_on = [
    module.public_subnet_a,
    module.public_subnet_c,
  ]
}

resource "aws_lb_target_group" "main" {
  name     = "${var.sys_name}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network_base.vpc_id
  depends_on = [
    module.network_base,
  ]

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "a" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.web_a.id
  port             = 80
  depends_on = [
    aws_instance.web_a,
  ]
}

resource "aws_lb_target_group_attachment" "c" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.web_c.id
  port             = 80
  depends_on = [
    aws_instance.web_c,
  ]
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
