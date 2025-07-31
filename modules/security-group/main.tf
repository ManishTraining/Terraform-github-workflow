resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

}

resource "aws_security_group_rule" "this" {
  count = length(var.ingress_rules)

  type                     = var.ingress_rules[count.index].type
  from_port                = var.ingress_rules[count.index].from_port
  to_port                  = var.ingress_rules[count.index].to_port
  protocol                 = var.ingress_rules[count.index].protocol
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.ingress_rules[count.index].source_security_group_id
  cidr_blocks              = var.ingress_rules[count.index].cidr_blocks
  description              = var.ingress_rules[count.index].description
}
