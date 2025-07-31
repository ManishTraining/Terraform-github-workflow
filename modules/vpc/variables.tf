# variables.tf
variable "project_name" {
  type    = string
  default = "fintech-mw"
}

variable "ipv4_primary_cidr_block" {
  type    = string
  default = null
}

variable "dns_hostnames_enabled" {
  type    = bool
  default = true
}

variable "private_subnets_cidr" {
  type    = list(string)
  default = []
}

variable "public_subnets_cidr" {
  type    = list(string)
  default = []
}

variable "availability_zones" {
  type        = list(string)
  description = "the various AZs in which to create subnets"
  default     = []
}

variable "nat_gw_enabled" {
  type    = bool
  default = true
} 
