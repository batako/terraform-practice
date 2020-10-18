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

# module "security_group_web" {
#   source      = "../../module/network/security_group"
#   sys_name    = var.sys_name
#   env         = var.env
#   name        = "${var.sys_name}-sg-web"
#   vpc_id      = module.network_preset.vpc_id
#   port        = 80
#   cidr_blocks = ["0.0.0.0/0"]
#   depends_on  = [module.network_preset]
# }

resource "aws_instance" "web" {
  ami                    = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type          = "t2.nano"
  subnet_id              = module.network_simple.subnet_public_id
  key_name               = var.sys_name
  vpc_security_group_ids = [module.security_group_vpc.id]
  # vpc_security_group_ids = [module.security_group_web.id]
  depends_on = [
    module.network_preset,
    module.security_group_vpc,
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
