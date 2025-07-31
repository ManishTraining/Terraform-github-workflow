#module vpc test

project = "abc"
opco    = "fintech"
country = "zf"
env     = "stage"
project_name = "fintech-zf"
region      = "ap-south-1"

vpc = {
  create                  = true
  ipv4_primary_cidr_block = "10.51.0.0/21"
  public_subnets_cidr     = ["10.51.0.0/24"]                   #["10.51.0.0/24"]
  private_subnets_cidr    = ["10.51.1.0/24"]
  availability_zones      = ["ap-south-1a", "ap-south-1b"]
}


ec2 = {
  lms = {
    ec2_subnet_id      = "private"  #"fintech-zf-private-subnet-0"
    ssh_key            = "test-key-pair"
    ami_id             = "ami-0d81f2cd09b410166"
    name               = "lms"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
    security_group_ids = ["abc-sg"]
    template_file      = null
    vpc_id             = null
  },
  api = {
    ec2_subnet_id      = "public"  #"fintech-zf-private-subnet-0"
    ssh_key            = "test-key-pair"
    ami_id             = "ami-0d81f2cd09b410166"
    name               = "api"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
    template_file      = null
    vpc_id             = null
    security_group_ids = ["abc-sg"]

  },
  worker = {
    ec2_subnet_id      = "private"  #"fintech-zf-private-subnet-0"
    ssh_key            = "test-key-pair"
    ami_id             = "ami-0d81f2cd09b410166"
    name               = "worker"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
    template_file      = "files/user_data/custom_ssh_port.sh"
    vpc_id             = null
    security_group_ids = ["abc-sg"]
  }
}

db = {
  create                          = false
  DbStorageSizeConfig             = 20
  DBEngineVersion                 = "14-12"
  DbInstanceClass                 = "db.m6gd.large"
  DbName                          = "fintech-zf"
  DbUserName                      = "fintech-zf"
  DbPassword                      = "fintechzfpwd"
  Port                            = 5432
  max_allocated_storage           = 100
  DBType                          = "Multi-AZ" # Change to "Single Node" if no HA is required
  BackupRetentionPeriod           = 7
  EnableCloudwatchLogsExports     = ["postgresql", "upgrade"]
  EnablePerformanceInsights       = false
  PerformanceInsightsRetentionPeriod = 7
  BackupWindow                    = "02:00-03:00"
  MasterDBMaintenanceWindow        = "Mon:03:00-Mon:04:00"
  DbStorageType                    = "gp2"
}

redis = {
  create                = false
  engine_version        = "7.1"                         #"6.2"
  node_type             = "cache.m7g.xlarge"            #"cache.t3.micro"
  num_cache_nodes       = 1
  az_mode               = "single-az"
  parameter_group_name  = "default.redis7"
  port                  = 6379
}

security_groups = {
  bastion                = true
  nginx                  = true
  lms                    = true
  rabbitmq               = true
}

rabbitmq = {
  engine_version         = "3.12.13"
  host_instance_type     = "mq.t3.micro"
  rabbitmq_username      = "rabbitmq_user"
}