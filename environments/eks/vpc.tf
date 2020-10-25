# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags                 = merge(local.default_tags, map("Name", "${local.default_tags.Name}-vpc"))
}

# Subnet

## Public
resource "aws_subnet" "pub_sn" {
  count                   = var.num_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index + 10)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index % var.num_subnets)
  map_public_ip_on_launch = true
  tags = merge(
    local.default_tags,
    map(
      "Name",
      "${local.default_tags.Name}-pub-sn-${
        split(
          "-",
          element(data.aws_availability_zones.available.names, count.index % var.num_subnets)
          )[
          length(
            split(
              "-",
              element(data.aws_availability_zones.available.names, count.index % var.num_subnets)
            )
          ) - 1
        ]
      }"
    ),
    map(
      "kubernetes.io/cluster/${local.cluster_name}",
      "shared"
    )
  )
}

# ## Private
# resource "aws_subnet" "priv_sn" {
#   count                   = var.num_subnets
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index + 20)
#   availability_zone       = element(data.aws_availability_zones.available.names, count.index % var.num_subnets)
#   map_public_ip_on_launch = false
#   tags = merge(
#     local.default_tags,
#     map(
#       "Name",
#       "${local.default_tags.Name}-priv-sn-${
#         split(
#           "-",
#           element(data.aws_availability_zones.available.names, count.index % var.num_subnets)
#           )[
#           length(
#             split(
#               "-",
#               element(data.aws_availability_zones.available.names, count.index % var.num_subnets)
#             )
#           ) - 1
#         ]
#       }"
#     )
#   )
# }

# ### Private Route Table
# resource "aws_route_table" "priv_rt" {
#   count  = var.num_subnets
#   vpc_id = aws_vpc.vpc.id

#   tags = merge(
#     local.default_tags,
#     map(
#       "Name",
#       "${local.default_tags.Name}-priv-rt-${
#         split(
#           "-",
#           element(data.aws_availability_zones.available.names, count.index % var.num_subnets)
#           )[
#           length(
#             split(
#               "-",
#               element(data.aws_availability_zones.available.names, count.index % var.num_subnets)
#             )
#           ) - 1
#         ]
#       }"
#     )
#   )
# }

# ### Private Route Table Association
# resource "aws_route_table_association" "priv_rta" {
#   count          = var.num_subnets
#   subnet_id      = element(aws_subnet.priv_sn.*.id, count.index)
#   route_table_id = element(aws_route_table.priv_rt.*.id, count.index)
# }

# ### Elastic IP for Private Subnet
# resource "aws_eip" "pub_eip" {
#   count = var.num_subnets
#   vpc   = true

#   tags = merge(
#     local.default_tags,
#     map(
#       "Name",
#       "${local.default_tags.Name}-priv-eip-${
#         split(
#           "-",
#           element(data.aws_availability_zones.available.names, count.index % var.num_subnets)
#           )[
#           length(
#             split(
#               "-",
#               element(data.aws_availability_zones.available.names, count.index % var.num_subnets)
#             )
#           ) - 1
#         ]
#       }"
#     )
#   )
# }

# ### Nat Gateway for Private Subnet
# resource "aws_nat_gateway" "pub_nat" {
#   count         = var.num_subnets
#   subnet_id     = element(aws_subnet.pub_sn.*.id, count.index)
#   allocation_id = element(aws_eip.pub_eip.*.id, count.index)

#   tags = merge(
#     local.default_tags,
#     map(
#       "Name",
#       "${local.default_tags.Name}-pub-nat-${
#         split(
#           "-",
#           element(data.aws_availability_zones.available.names, count.index % var.num_subnets)
#           )[
#           length(
#             split(
#               "-",
#               element(data.aws_availability_zones.available.names, count.index % var.num_subnets)
#             )
#           ) - 1
#         ]
#       }"
#     )
#   )
# }

# ### Private Subnet Route
# resource "aws_route" "priv_r" {
#   count                  = var.num_subnets
#   route_table_id         = element(aws_route_table.priv_rt.*.id, count.index)
#   nat_gateway_id         = element(aws_nat_gateway.pub_nat.*.id, count.index)
#   destination_cidr_block = "0.0.0.0/0"
# }

# Public Route Table
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.default_tags, map("Name", "${local.default_tags.Name}-pub-rt"))
}

# Public Route Table Association
resource "aws_route_table_association" "pub_rta" {
  count          = var.num_subnets
  subnet_id      = element(aws_subnet.pub_sn.*.id, count.index)
  route_table_id = aws_route_table.pub_rt.id
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.default_tags, map("Name", "${local.default_tags.Name}-igw"))
}

# Security Group

## Master
resource "aws_security_group" "eks_master" {
  name   = "${local.default_tags.Name}-master-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
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

  tags = merge(local.default_tags, map("Name", "${local.default_tags.Name}-master-sg"))
}

## Node
resource "aws_security_group" "eks_node" {
  name   = "${local.default_tags.Name}-node-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_master.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_master.id]
    self            = false
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags, map("Name", "${local.default_tags.Name}-node-sg"))
}
