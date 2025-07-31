#module vpc test

project = "abc"
opco    = "fintech"
country = "tz"
env     = "stage"
project_name = "fintech-tz"
region       = "ap-south-1"

vpc = {
  create                  = true  # vpc-9d486cf5
  ipv4_primary_cidr_block = "10.51.0.0/16"
  public_subnets_cidr     = ["10.51.0.0/24"]
  private_subnets_cidr    = ["10.51.3.0/24", "10.51.5.0/24"]
  availability_zones      = ["ap-south-1a", "ap-south-1b"]
}

#ec2 module
ec2 = {
  test-lms-web1 = {
    ec2_subnet_id      = "public"  #"fintech-tz-private-subnet-0"    #subnet-b0edafd8"   #"fintech-tz-private-subnet-0"   #pvt=subnet-0443c154bd6a4b691 pub=subnet-b0edafd8
    ssh_key            = "test-key-pair"
    ami_id             = "ami-0d81f2cd09b410166"
    name               = "test-lms-web1"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
    security_group_ids = ["sg-0a04226f4cddbfa51"]
    template_file      = "files/user_data/custom_ssh_port.sh"
    vpc_id             = null
  }
}

db = {
  create                          = false
}

redis = {
  create                           = false
}
security_groups = {
  bastion                = false
  nginx                  = false
  lms                    = true
  #rabbitmq               = true
}
/*
rabbitmq = {
  engine_version         = "3.12.13"
  host_instance_type     = "mq.t3.micro"
  rabbitmq_username      = "rabbitmq_user"
}
*/