variable "name" {
  type        = string
  description = "Name for the security group"
}

variable "description" {
  type        = string
  description = "Description for the security group"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the security group will be created"
}

variable "ingress_rules" {
  type = list(object({
    type                     = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
    description              = optional(string)
  }))
}
