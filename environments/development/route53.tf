data "aws_route53_zone" "selected" {
  name = "batako.net"
}

resource "aws_route53_record" "terraform" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "batako.net"
  type    = "A"
  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
  depends_on = [
    aws_lb.main,
  ]
}
