#module vpc test

project             = "yabx"
opco                = "airtel"
country             = "od"
env                 = "stage"
project_name        = "airtel-od"
region              = "ap-south-2"

vpc = {
  create                   = false  // need to give vpc id and exact subnet id explicitly with every ec2
  #ipv4_primary_cidr_block = "10.51.0.0/21"
  #public_subnets_cidr     = ["10.51.0.0/24"] #["10.51.0.0/24"]
  #private_subnets_cidr    = ["10.51.4.0/24"] # ["10.51.4.0/24", "10.51.5.0/24"]
  #availability_zones      = ["ap-south-2a", "ap-south-2b"]
}

#ec2 module

ec2 = {
  testapi12 = {
    ec2_subnet_id      = "subnet-0194b85c3c1e2afc3"    # a subnet id in defaut subnet #"airtel-od-private-subnet-0"   #"subnet-0c16c6605f1d13f1f"  # airtel tz pvt subnet 
    vpc_id             = "vpc-079e87a5968a56f9d"   # default vpc id  #### mandatory in stage where vpc create is false
    ssh_key            = "test-key-pair"   # give ur ssh key
    ami_id             = "ami-0d81f2cd09b410166"
    name               = "testapi3"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
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
  #rabbitmq               = false
}