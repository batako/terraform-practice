data "aws_ami" "recent_amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????.0-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

module "security_group_web" {
  source   = "../../module/network/security_group"
  sys_name = var.sys_name
  env      = var.env
  name     = "${var.sys_name}-sg-web"
  vpc_id   = module.network_base.vpc_id
  # port        = 80
  # cidr_blocks = ["0.0.0.0/0"]
  depends_on = [module.network_base]
}

resource "aws_security_group_rule" "ingress-web" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.security_group_web.id
}

resource "aws_security_group_rule" "ingress-ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # TODO: アクセス元のIPアドレスを入力
  #       直接変更するのは面倒なので何かいい方法を考える
  cidr_blocks       = ["116.94.167.212/32"]
  security_group_id = module.security_group_web.id

  lifecycle {
    ignore_changes = [cidr_blocks]
  }
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.security_group_web.id
}

resource "aws_instance" "web_a" {
  ami           = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type = "t2.nano"
  subnet_id     = module.public_subnet_a.id
  key_name      = var.sys_name
  # vpc_security_group_ids = [module.security_group_vpc.id]
  vpc_security_group_ids = [module.security_group_web.id]
  depends_on = [
    module.public_subnet_a,
    # module.security_group_vpc,
  ]

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd.service
systemctl start httpd.service
EOF

  tags = {
    Name = "${var.sys_name}-web"
    Env  = var.env
  }
}

resource "aws_instance" "web_c" {
  ami                    = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type          = "t2.nano"
  subnet_id              = module.public_subnet_c.id
  key_name               = var.sys_name
  vpc_security_group_ids = [module.security_group_web.id]
  depends_on = [
    module.public_subnet_c,
  ]

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd.service
systemctl start httpd.service
EOF

  tags = {
    Name = "${var.sys_name}-web"
    Env  = var.env
  }
}
