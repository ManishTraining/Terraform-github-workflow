resource "aws_elasticache_cluster" "redis-cluster" {
  cluster_id               = "${var.project_name}-${var.env}-redis-cluster"
  engine                   = "redis"
  engine_version           = var.engine_version 
  node_type                = var.node_type 
  num_cache_nodes          = var.num_cache_nodes 
  az_mode                  = var.az_mode 
  parameter_group_name     = var.parameter_group_name 
  port                     = var.port
  security_group_ids       = [aws_security_group.RedisSecurityGroup.id]
  subnet_group_name        = aws_elasticache_subnet_group.redis-sb-grp.name

  depends_on               = [aws_elasticache_subnet_group.redis-sb-grp]
  tags = {
  Name    = "${var.project_name}-${var.env}-redis-cluster"
  project = var.project_name
}

}

resource "aws_elasticache_subnet_group" "redis-sb-grp" {
  name       = "${var.project_name}-redis-sb-grp"
  subnet_ids = var.subnet_ids
  
  tags = {
    Name = "${var.project_name}-redis-sb-grp"
    project = var.project_name
  }
}



resource "aws_security_group" "RedisSecurityGroup" {
    name = "${var.project_name}-redis-sg"
    vpc_id =  var.vpc_id
/*
    ingress {
        from_port = 6379
        to_port = 6379
        protocol = "tcp"
        security_groups = aws_security_group.ec2_sg1.id       /////////////////////////// need to see

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
*/
    tags = {
      Name    = "${var.project_name}-redis-sg"
      project = var.project_name
  }
}
