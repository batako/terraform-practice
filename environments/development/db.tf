module "security_group_db" {
  source   = "../../module/network/security_group"
  sys_name = var.sys_name
  env      = var.env
  name     = "${var.sys_name}-sg-db"
  vpc_id   = module.network_base.vpc_id
  # port        = 80
  # cidr_blocks = ["0.0.0.0/0"]
  depends_on = [module.network_base]
}

resource "aws_security_group_rule" "ingress_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.security_group_db.id
  source_security_group_id = module.security_group_web.id
  depends_on               = [module.security_group_web]
}

resource "aws_db_subnet_group" "tf" {
  name = "${var.sys_name}-db-group"
  subnet_ids = [
    module.private_subnet_a.id,
    module.private_subnet_c.id,
  ]
  depends_on = [
    module.private_subnet_a,
    module.private_subnet_c,
  ]

  tags = {
    Name = "${var.sys_name}-db-group"
    Env  = var.env
  }
}

resource "aws_db_parameter_group" "tf" {
  name        = "${var.sys_name}-db-pg"
  family      = "mysql8.0"
  description = "${var.sys_name}-db-pg"
}

resource "aws_db_option_group" "mysql" {
  name                     = "${var.sys_name}-db-og"
  option_group_description = "${var.sys_name}-db-og"
  engine_name              = "mysql"
  major_engine_version     = "8.0"
}

resource "aws_db_instance" "mysql_a" {
  identifier     = "${var.sys_name}-db"
  engine         = "mysql"
  engine_version = "8.0.20"
  name           = "terraformdb"
  # TODO: ID/PW を入力
  #       直接変更するのは面倒なので何かいい方法を考える
  username               = "ID"
  password               = "PW"
  instance_class         = "db.t2.micro"
  storage_type           = "gp2"
  allocated_storage      = 20
  vpc_security_group_ids = [module.security_group_db.id]
  db_subnet_group_name   = aws_db_subnet_group.tf.name
  availability_zone      = "${var.region}a"
  skip_final_snapshot    = true

  lifecycle {
    ignore_changes = [
      username,
      password,
    ]
  }
}

resource "aws_db_instance" "mysql_c" {
  identifier     = "${var.sys_name}-db"
  engine         = "mysql"
  engine_version = "8.0.20"
  name           = "terraformdb"
  # TODO: ID/PW を入力
  #       直接変更するのは面倒なので何かいい方法を考える
  username               = "ID"
  password               = "PW"
  instance_class         = "db.t2.micro"
  storage_type           = "gp2"
  allocated_storage      = 20
  vpc_security_group_ids = [module.security_group_db.id]
  db_subnet_group_name   = aws_db_subnet_group.tf.name
  availability_zone      = "${var.region}c"
  skip_final_snapshot    = true

  lifecycle {
    ignore_changes = [
      username,
      password,
    ]
  }
}
