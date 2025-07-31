#Common variables

variable "env" {
  type    = string
  default = "stage"
}
variable "opco" {
  type    = string
  default = "fintech"
}
variable "country" {
  type    = string
  default = "mw"
}
variable "project_name" {
  type    = string
  default = "fintech-mw"
}
variable "region" {
  type    = string
  default = "ap-south-1"
}
#VPC variables
variable "vpc" {
  default = {}
}

#EC2 module variables
variable "ec2" {
  default = {}
}
#RDS module variables
variable "db" {
  default = {}
}
#REDIS module variables
variable "redis" {
  default = {}
}

#SECURITY_GROUP module variables
variable "security_groups" {
  default = {}
}

variable "rabbitmq" {
  default = {}
}