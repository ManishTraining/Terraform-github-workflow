#module vpc test noted


opco    = "fintech"
country = "india"
env     = "stage"
project_name = "fintech-india"
region       = "ap-south-1"

vpc = {
  create                  = true
  ipv4_primary_cidr_block = "10.51.0.0/16"
  public_subnets_cidr     = ["10.51.0.0/24"]
  private_subnets_cidr    = ["10.51.4.0/24"]
  availability_zones      = ["ap-south-1a", "ap-south-1b"]
}

ec2 = {
  fintech-bastion = {
    ec2_subnet_id      = "public"  # no need to give vpc id separaetly "fintech-india-public-subnet-0"    #"subnet-0c2a30d3f0c07367f"  # give subnet name 
    ssh_key            = "test-key-pair"
    ami_id             = "ami-0b09627181c8d5778" 
    name               = "fintech-bastion"
    instance_type      = "t2.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
    vpc_id             = null
    template_file      = "files/user_data/custom_ssh_port.sh"
    security_group_ids = ["sg-02754b82f92b5a703"]
  
  }
  /*
  api1 = {
    ec2_subnet_id      = "public" #"fintech-india-private-subnet-0"  # give subnet name 
    ssh_key            = "test-key-pair"
    ami_id             = "ami-0b09627181c8d5778" 
    name               = "test1"
    instance_type      = "t2.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
    vpc_id             = null
    template_file      = "files/user_data/custom_ssh_port.sh"
    security_group_ids = ["sg-04e28c73c603472a9"]
  },
  test_worker1 = {
    ec2_subnet_id      = "private" #"fintech-india-private-subnet-0"  # trying giving pub subnet id manually by picking from ui 
    ssh_key            = "test-key-pair"
    ami_id             = "ami-0b09627181c8d5778" 
    name               = "test_worker1"
    instance_type      = "t2.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
    vpc_id             = null
    template_file      = "files/user_data/custom_ssh_port.sh"
    security_group_ids = ["sg-04e28c73c603472a9"]
  }
  */
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