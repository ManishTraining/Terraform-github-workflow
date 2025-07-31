provider "aws" {
  region = var.region
}


module "vpc" {
  count                   = var.vpc.create ? 1 : 0
  source                  = "./modules/vpc"     #"../vpc"
  project_name             = var.project_name
  ipv4_primary_cidr_block = var.vpc.ipv4_primary_cidr_block
  public_subnets_cidr     = var.vpc.public_subnets_cidr
  private_subnets_cidr    = var.vpc.private_subnets_cidr
  availability_zones      = var.vpc.availability_zones
}



module "ec2" {
  source               = "./modules/ec2"
  for_each             = var.ec2
  project_name          = var.project_name
  ami_id               = each.value.ami_id
  name                 = "${var.project_name}-${var.env}-${each.value.name}"
  instance_type        = each.value.instance_type
  #ec2_subnet_id        = each.value.ec2_subnet_id == "" ? module.vpc[0].private_subnet_ids[0] : each.value.ec2_subnet_id
  ec2_subnet_id        = var.vpc.create ? (each.value.ec2_subnet_id == "private" ? module.vpc[0].private_subnet_ids[0] : each.value.ec2_subnet_id == "public" ? module.vpc[0].public_subnet_ids[0] : module.vpc[0].private_subnet_ids[0]) : each.value.ec2_subnet_id
  #ec2_subnet_id        = each.value.ec2_subnet_id
  source_dest_check    = each.value.source_dest_check
  ec2_storage          = each.value.ec2_storage
  volume_type          = each.value.volume_type
  ssh_key              = each.value.ssh_key                           #"${var.project_name}-${var.ssh_key}"
  user_data            = each.value.template_file != null ? data.template_file.user_data[each.key].rendered : null
  iam_instance_profile = ""
  #vpc_id               = module.vpc[0].vpc_id
  #vpc_id               = var.vpc.create ? module.vpc[0].vpc_id : each.value.vpc_id
  vpc_id                = coalesce( var.vpc.create ? module.vpc[0].vpc_id : null, each.value.vpc_id)   #(module.vpc[0].vpc_id, each.value.vpc_id)
  vpc_security_group_ids= each.value.security_group_ids
}

data "template_file" "user_data" {
  for_each = var.ec2
  template = try(file(each.value.template_file), null)
}

module "rds" {
  count                           = var.db.create ? 1 : 0
  source                          = "./modules/rds"
  env                             = var.env
  project_name                    = var.project_name
  DbStorageSizeConfig             = var.db.DbStorageSizeConfig
  DbEngine                        = "Postgres"
  DBEngineVersion                 = var.db.DBEngineVersion
  DbInstanceClass                 = var.db.DbInstanceClass
  DbName                          = var.db.DbName
  DbUserName                      = var.db.DbUserName
  DbPassword                      = var.db.DbPassword
  Port                            = 5432
  max_allocated_storage           = var.db.max_allocated_storage
  DBType                          = var.db.DBType
  BackupRetentionPeriod           = var.db.BackupRetentionPeriod
  EnableCloudwatchLogsExports     = var.db.EnableCloudwatchLogsExports
  EnablePerformanceInsights       = var.db.EnablePerformanceInsights
  PerformanceInsightsRetentionPeriod = var.db.PerformanceInsightsRetentionPeriod
  BackupWindow                    = var.db.BackupWindow
  MasterDBMaintenanceWindow        = var.db.MasterDBMaintenanceWindow
  DbStorageType                    = "gp2"
  subnet_ids                       = module.vpc[0].private_subnet_ids
  vpc_id                           = module.vpc[0].vpc_id
}

module "redis" {
  count                 = var.redis.create ? 1 : 0
  source                = "./modules/redis"  
  project_name          = var.project_name
  env                   = var.env
  engine_version        = var.redis.engine_version
  node_type             = var.redis.node_type
  num_cache_nodes       = var.redis.num_cache_nodes
  az_mode               = var.redis.az_mode
  parameter_group_name  = var.redis.parameter_group_name
  port                  = var.redis.port
  subnet_ids            = module.vpc[0].private_subnet_ids
  vpc_id                = module.vpc[0].vpc_id
}

module "bastion_sg" {
  count       = var.security_groups.bastion == true ? 1 : 0
  source      = "./modules/security-group"
  name        = "${var.project_name}-bastion-sg"
  description = "${var.project_name}-bastion security group"
  vpc_id      = module.vpc[0].vpc_id
  ingress_rules = [
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow ssh at 22 from anywhere"
    },
      {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}

#module.bastion_sg[0].security_group_id
#module.public_nginx_sg[0].security_group_id
#module.bastiolms_sgn_sg[0].security_group_id


module "public_nginx_sg" {
  count       = var.security_groups.nginx == true ? 1 : 0
  source        = "./modules/security-group"
  name        = "${var.project_name}-nginx-sg"
  description = "${var.project_name}-nginx security group"
  vpc_id        = module.vpc[0].vpc_id
  ingress_rules = [
    {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      description = "Allow port 80 from anywhere"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      description = "Allow port 443 from anywhere"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      source_security_group_id = module.bastion_sg[0].security_group_id  #var.vpc.public_subnets_cidr
      description = "Allow ssh at port 22 from bastion"
    },
    {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }

  ]
}
module "lms_sg" {
  count       = var.security_groups.lms == true ? 1 : 0
  source      = "./modules/security-group"
  name        = "${var.project_name}-lms-sg"
  description = "${var.project_name}-lms security group"
  vpc_id      = module.vpc[0].vpc_id
  ingress_rules = [
    {
      type        = "ingress"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = [var.vpc.ipv4_primary_cidr_block]
      description = "Allow at port 3000 from inside vpc"
    },
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      #source_security_group_id = module.bastion_sg[0].security_group_id  #var.vpc.public_subnets_cidr
      description = "Allow ssh at port 22 from bastion"
    },
    {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}
/*
module "mq_rabbitmq_sg" {

  count       = var.security_groups.rabbitmq == true ? 1 : 0
  source      = "./modules/security-group"
  name        = "${var.project_name}-rabbitmq-sg"
  description = "${var.project_name}-rabbitmq security group"
  vpc_id      = var.rabbitmq.vpc_id
  ingress_rules = [
    {
      type        = "ingress"
      from_port   = 5672
      to_port     = 5672
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  #[var.vpc.ipv4_primary_cidr_block]
      description = "Allow at port 3000 from inside vpc"
    },
    {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]

}

module "rabbitmq" {
  source = "./modules/rabbitmq"

  broker_name        = "${var.project_name}-rabbitmq-broker"
  engine_version     = var.rabbitmq.engine_version
  host_instance_type = var.rabbitmq.host_instance_type
  security_groups    = [module.mq_rabbitmq_sg[0].security_group_id]
  subnet_ids         = var.rabbitmq.subnet_ids   #module.vpc[0].public_subnet_ids   #[module.vpc[0].public_subnet_ids[0]]
  username           = var.rabbitmq.rabbitmq_username
  password           = random_password.rabbitmq_password.result
}

resource "random_password" "rabbitmq_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

output "rabbitmq_password" {
  value     = random_password.rabbitmq_password.result
  sensitive = true  # ✅ Hides it from logs
}

*/