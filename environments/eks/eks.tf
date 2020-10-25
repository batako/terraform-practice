resource "aws_eks_cluster" "cluster" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_master.arn
  version  = local.cluster_version

  vpc_config {
    security_group_ids = [aws_security_group.eks_master.id]
    subnet_ids         = aws_subnet.pub_sn.*.id
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster,
    aws_iam_role_policy_attachment.eks_service,
  ]
}

resource "aws_eks_node_group" "ng" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${local.base_name}-ng"
  node_role_arn   = aws_iam_role.eks_node.arn
  instance_types  = var.instance_types
  subnet_ids      = aws_subnet.pub_sn.*.id

  remote_access {
    ec2_ssh_key = var.key_name
    # TODO
    # source_security_group_ids = []
  }

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  tags = merge(local.default_tags, map("Name", "${local.default_tags.Name}-ng"))

  depends_on = [
    aws_iam_role.eks_node,
    aws_subnet.pub_sn,
  ]
}
