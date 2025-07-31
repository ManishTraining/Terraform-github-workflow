#module vpc test

project = "abc"
opco    = "furaha"
env     = "dev"
project_name = "furaha-dev"
region       = "ap-south-2"

vpc = {
  create                  = false  # vpc-9d486cf5
}

#ec2 module
ec2 = {
  lms = {
    ec2_subnet_id      = "subnet-0ac77801b5b434092" #"give-id-here"  #  ###  "public"  #"fintech-tz-private-subnet-0"    #subnet-b0edafd8"   #"fintech-tz-private-subnet-0"   #pvt=subnet-0443c154bd6a4b691 pub=subnet-b0edafd8
    ssh_key            = "test-key-pair"    #"give pem key here"  ###  
    ami_id             = "ami-0a94a70b8a1454a4b"  #ubuntu 22
    name               = "lms"
    instance_type      = "t3.micro"
    source_dest_check  = "true"
    ec2_storage        = "30"  # Maximum size under Free Tier
    volume_type        = "gp2"
    security_group_ids = ["sg-0a762c3e02a87df99"] #["sg-014c96c48dc1b95de"]   #####
    template_file      = "files/user_data/custom_ssh_port.sh"
    vpc_id             = "vpc-0e922ecca60b23b56"     #"vpc-079e87a5968a56f9d"
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
  lms                    = false
  rabbitmq               = true
}

rabbitmq = {
  engine_version         = "3.12.13"
  host_instance_type     = "mq.t3.micro"
  rabbitmq_username      = "rabbitmq_user"
  vpc_id                 = "vpc-0e922ecca60b23b56" 
  subnet_ids             = ["subnet-0ddc26c692b5a3559"]  #"subnet-0a248024b447daeb4"
}
