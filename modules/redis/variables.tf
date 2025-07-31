
variable "project_name" {
  type    = string
  default = "airtel-mw"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "engine_version" {
  type    = string
  default = "7.1"
}
variable "node_type" {
  type    = string
  default = "cache.m7g.xlarge"
}

variable "num_cache_nodes" {
  type    = number
  default = 1
}

variable "az_mode" {
  type    = string
  default = "single-az"
}

variable "parameter_group_name" {
  type    = string
  default = "default.redis7"
}

variable "port" {
  type    = number
  default = 6300
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}
variable "subnet_ids" {

}
variable "vpc_id" {
  type        = string
}
