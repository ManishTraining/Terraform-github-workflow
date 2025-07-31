#module vpc test

project = "abc-test"
opco    = "fintech"
country = "zambia"
env     = "prod"
project_name = "fintech-zambia"
region       = "ap-south-1"


vpc = {
  create                  = true    # then vpc_id             = null needed
  ipv4_primary_cidr_block = "10.51.0.0/16"
  public_subnets_cidr     = ["10.51.0.0/24"]
  private_subnets_cidr    = ["10.51.4.0/24","10.51.5.0/24"]   # "10.51.5.0/24"
  availability_zones      = ["ap-south-1a", "ap-south-1b"]
}

#ec2 module
ec2 = {
  nginx = {
    ec2_subnet_id      = "public"   #"fintech-zambia-private-subnet-0"
    ssh_key            = "test-key-pair"
    ami_id             = "ami-083d7ff73dafd9229"   #"ami-008f39a0a3cddb14d" #graviton #"ami-0d81f2cd09b410166"
    name               = "nginx"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
    template_file      = "files/user_data/custom_ssh_port.sh"  #null
    vpc_id             = null
    security_group_ids = ["sg-04cff4879e3dfc8ea"]
  },
  lms-api-1 = {
    ec2_subnet_id      = "private"   #"fintech-zambia-private-subnet-0"
    ssh_key            = "test-key-pair"
    ami_id             = "ami-083d7ff73dafd9229"     #"ami-0d81f2cd09b410166"
    name               = "lms-api-1"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"
    volume_type        = "gp2"
    template_file      = "files/user_data/custom_ssh_port.sh"
    vpc_id             = null
    security_group_ids = ["sg-0ad14ee768e4e2c84"]
  },
    bastion = {
    ec2_subnet_id      = "public"   #"fintech-zambia-private-subnet-0"
    ssh_key            = "test-key-pair"
    ami_id             = "ami-083d7ff73dafd9229"     #"ami-0d81f2cd09b410166"
    name               = "bastion"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"
    volume_type        = "gp2"
    template_file      = "files/user_data/custom_ssh_port.sh"
    vpc_id             = null
    security_group_ids = ["sg-0490183e654090281"]
  },
    lms-api-2 = {
    ec2_subnet_id      = "private"   #"fintech-zambia-private-subnet-0"
    ssh_key            = "test-key-pair"
    ami_id             = "ami-083d7ff73dafd9229"     #"ami-0d81f2cd09b410166"
    name               = "lms-api-2"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"
    volume_type        = "gp2"
    template_file      = "files/user_data/custom_ssh_port.sh"
    vpc_id             = null
    security_group_ids = ["sg-0ad14ee768e4e2c84"]
  }
}
db = {
  create                          = false
  DbStorageSizeConfig             = 20
  DBEngineVersion                 = "14.12"
  DbInstanceClass                 = "db.m6gd.large"  #"db.t3.medium"  Standard classes (includes m classes)
  DbName                          = "testfintechzambia"
  DbUserName                      = "testfintechzambia"
  DbPassword                      = "testfintechzambiapwd"
  Port                            = 5432
  max_allocated_storage           = 100
  DBType                          = "Multi-AZ" # Change to "Single Node" if no HA is required
  BackupRetentionPeriod           = 7
  EnableCloudwatchLogsExports     = ["postgresql", "upgrade"]
  EnablePerformanceInsights       = false
  PerformanceInsightsRetentionPeriod = 7
  BackupWindow                       = "02:00-03:00"
  MasterDBMaintenanceWindow          = "Mon:03:00-Mon:04:00"
  DbStorageType                      = "gp2"
}

redis = {
  create                = false
  engine_version        = "7.1"                         #"6.2"
  node_type             = "cache.m7g.xlarge"            #"cache.t3.micro"
  num_cache_nodes       = 1
  az_mode               = "single-az"   #default is single-az. If you want to choose cross-az, num_cache_nodes must be greater than 1.
  parameter_group_name  = "default.redis7"
  port                  = 6379
}

security_groups = {
  bastion                = true
  nginx                  = true
  lms                    = true
}