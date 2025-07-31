# variables.tf
variable "instance_type" {
  type = string
}
variable "ec2_subnet_id" {
  type = string
}
variable "ec2_storage" {
  type = string
}
variable "name" {
  type = string
}
variable "ami_id" {
  type = string
}
variable "ssh_key" {
  type = string
}
variable "user_data" {
  type    = string
  default = null
}
variable "volume_type" {
  type = string
}
variable "source_dest_check" {
  type = bool
}
variable "iam_instance_profile" {
  type = string
}

variable "vpc_id" {
  type = string
}


variable "project_name" {
  type    = string
  default = "fintech-mw"
}

variable "vpc_security_group_ids" {
  default = []
}