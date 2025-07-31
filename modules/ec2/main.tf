# module to create EC2 instance
/*
data "aws_subnets" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.ec2_subnet_id]
  }
}
*/
resource "aws_instance" "ec2" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  subnet_id               = var.ec2_subnet_id 
  vpc_security_group_ids  = var.vpc_security_group_ids
  iam_instance_profile    = var.iam_instance_profile
  disable_api_termination = false
  key_name                = var.ssh_key
  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.ec2_storage
    delete_on_termination = true
  }
  user_data         = var.user_data
  tags = {
    Name = var.name
    project = var.project_name
  }
  #depends_on = [aws_security_group.EC2SecurityGroup]
}


/*
data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.ec2_subnet_id]
  }
}

resource "aws_security_group" "EC2SecurityGroup" {
    name         = "${var.name}-ec2-sg"
    vpc_id       = var.vpc_id    #data.aws_subnet.selected.vpc_id   #
      tags = {
          Name = "${var.name}-ec2-sg"
          project = var.project_name
          ManagedBy = "terraform"
      }
    }
*/