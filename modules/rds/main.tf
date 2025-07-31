# RDS MASTER DATABASE INSTANCE
resource "aws_db_instance" "MasterDb" {
  identifier                      = lower("${var.project_name}-${var.env}-db-instance")
  allocated_storage               = var.DbStorageSizeConfig
  engine                          = var.DbEngine
  engine_version                  = var.DBEngineVersion
  instance_class                  = var.DbInstanceClass
  db_name                         = var.DbName
  username                        = var.DbUserName
  password                        = var.DbPassword
  publicly_accessible             = false
  skip_final_snapshot             = true # false for prod and true for stage or testing,once the database is deleted, all backups and snapshots are also deleted, unless you explicitly take a final snapshot.
  final_snapshot_identifier       = lower("${var.project_name}-${var.env}-db-instance-snapshot")
  apply_immediately               = true
  port                            = var.Port
  storage_encrypted               = true
  deletion_protection             = true
  max_allocated_storage           = var.max_allocated_storage  #min 20 GB
  multi_az                        = var.DBType != "Single Node"
  performance_insights_enabled    = false    # incurs cost
  backup_retention_period         = var.BackupRetentionPeriod
  iam_database_authentication_enabled = true
  copy_tags_to_snapshot           = true
  enabled_cloudwatch_logs_exports = var.EnableCloudwatchLogsExports
  depends_on                      = [aws_db_subnet_group.rds-subnet-grp]
  vpc_security_group_ids          = [aws_security_group.DatabaseSecurityGroup.id]    #  created in same file
  db_subnet_group_name            = aws_db_subnet_group.rds-subnet-grp.name

  # Additional optional configurations
  allow_major_version_upgrade         = false  # like 12.x → 13.x  database engine will remain on the current major version unless explicitly upgraded.
  auto_minor_version_upgrade          = false # like 13.3 → 13.14 By default, AWS RDS enables automatic minor version upgrades to ensure that databases remain secure and up-to-date with the latest patches.
  performance_insights_retention_period = var.EnablePerformanceInsights ? var.PerformanceInsightsRetentionPeriod : null
  backup_window                       = var.BackupWindow
  maintenance_window                  = var.MasterDBMaintenanceWindow
  storage_type                        = var.DbStorageType
  delete_automated_backups            = false

  tags = {
    Name      = lower("${var.project_name}-${var.env}-db-instance")
    project   = var.project_name
    ManagedBy = "Terraform"
  }

  lifecycle {
    ignore_changes = [password, performance_insights_enabled, engine_version]
  }
}

resource "aws_db_instance" "Read-replica-db" {
  identifier                     = "${aws_db_instance.MasterDb.identifier}-replica"
  instance_class                 = var.DbInstanceClass
  skip_final_snapshot            = true
  backup_retention_period        = 7
  replicate_source_db            = aws_db_instance.MasterDb.identifier
}

# TIME DELAY TO ENSURE STABILITY AFTER INSTANCE CREATION
resource "time_sleep" "Wait30Seconds" {
  depends_on = [aws_db_instance.MasterDb]
  create_duration = "120s"
}

# RDS SUBNET GROUP
resource "aws_db_subnet_group" "rds-subnet-grp" {
  name       = lower("${var.project_name}-${var.env}-rds-subnet-grp")
  subnet_ids = var.subnet_ids                 # module.vpc[0].private_subnet_ids

  tags = {
    Name    = lower("${var.project_name}-${var.env}-rds-subnet-grp")
    project = var.project_name
  }
}



resource "aws_security_group" "DatabaseSecurityGroup" {
    name = "${var.project_name}-rds-sg"
    vpc_id =  var.vpc_id  #module.vpc[0].vpc_id

    tags = {
      Name    = "${var.project_name}-rds-sg"
      project = var.project_name
  }
}
