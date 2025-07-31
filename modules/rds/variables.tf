variable "project_name" {
  type    = string
  default = "airtel-mw"
}

variable "env" {
  type    = string
  default = "stage"
}


variable "DBType" {
  type        = string
  description = "Database type, e.g., Single Node or Multi-AZ"
  default     = "Single Node"
}

variable "DbName" {
  type        = string
  description = "Name of database schema"
  default     = "bludb"
}

variable "DbEngine" {
  type        = string
  description = "Name of database engine"
  default     = "postgres"
}

variable "DBEngineVersion" {
  type        = string
  description = "Database engine version"
  default     = "13.14"
}

variable "DbUserName" {
  type        = string
  description = "Database username"
  default     = "bluadmin"
}

variable "DbPassword" {
  type        = string
  description = "Database password"
}

variable "DbStorageSizeConfig" {
  type        = number
  description = "Database storage size in GB"
  default     = 100
}

variable "DbStorageType" {
  type        = string
  description = "Database storage type"
  default     = "gp2"
}

variable "DbInstanceClass" {
  type        = string
  description = "Instance class for database"
  default     = "db.t3.medium"
}

variable "Port" {
  type        = number
  description = "Database port"
  default     = 5432
}

variable "max_allocated_storage" {
  type        = number
  description = "Maximum allocated storage for database"
  default     = 100
}

variable "BackupRetentionPeriod" {
  type        = number
  description = "Backup retention period in days"
  default     = 7
}

variable "BackupWindow" {
  type        = string
  description = "Preferred backup window"
  default     = "02:00-03:00"
}

variable "MasterDBMaintenanceWindow" {
  type        = string
  description = "Preferred maintenance window for master DB"
  default     = "Sun:04:00-Sun:05:00"
}

variable "EnablePerformanceInsights" {
  type        = bool
  description = "Enable Performance Insights"
  default     = true
}

variable "PerformanceInsightsRetentionPeriod" {
  type        = number
  description = "Performance Insights retention period in days"
  default     = 7
}

variable "EnableCloudwatchLogsExports" {
  type        = list(string)
  description = "List of CloudWatch log types to export"
  default     = ["postgresql", "upgrade"]
}
variable "subnet_ids" {

}
variable "vpc_id" {
  type        = string
}


