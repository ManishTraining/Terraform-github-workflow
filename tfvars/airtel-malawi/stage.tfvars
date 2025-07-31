#module vpc test


opco    = "fintech"
country = "india"
env     = "stage"
project_name = "fintech-india"
region       = "ap-south-1"

vpc = {
  create                  = true
  ipv4_primary_cidr_block = "10.51.0.0/16"
  public_subnets_cidr     = ["10.51.0.0/24"]
  private_subnets_cidr    = ["10.51.4.0/24","10.51.5.0/24"]
  availability_zones      = ["ap-south-1a", "ap-south-1b"]
}

ec2 = {
  bastion1 = {
    ec2_subnet_id      = "public"  # no need to give vpc id separaetly "fintech-india-public-subnet-0"    #"subnet-0c2a30d3f0c07367f"  # give subnet name 
    ssh_key            = "test-key-pair"
    ami_id             = "ami-0d81f2cd09b410166" #"ami-0f5ee92e2d63afc18"
    name               = "bastion1"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
    vpc_id             = null
    template_file      = "files/user_data/custom_ssh_port.sh"
    security_group_ids = ["sg-0e2d8d824cca33c85"]
    
  },
  api1 = {
    ec2_subnet_id      = "public" #"fintech-india-private-subnet-0"  # give subnet name 
    ssh_key            = "test-key-pair"
    ami_id             = "ami-0d81f2cd09b410166" #"ami-0f5ee92e2d63afc18"
    name               = "test1"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
    vpc_id             = null
    template_file      = "files/user_data/custom_ssh_port.sh"
    security_group_ids = ["sg-0e2d8d824cca33c85"]
  },
  test_worker1 = {
    ec2_subnet_id      = "private" #"fintech-india-private-subnet-0"  # trying giving pub subnet id manually by picking from ui 
    ssh_key            = "test-key-pair"
    ami_id             = "ami-0d81f2cd09b410166" #"ami-0f5ee92e2d63afc18"
    name               = "test_worker1"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
    vpc_id             = null
    template_file      = "files/user_data/custom_ssh_port.sh"
    security_group_ids = ["sg-0e2d8d824cca33c85"]
  }
}

db = {
  create                = false
}

redis = {
  create = false
}
security_groups = {
  bastion                = false
  nginx                  = false
  lms                    = false
}