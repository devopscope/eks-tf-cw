variable "env" {
  description = "The value of environment"
  type = string
  default = "dev"
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR (Classless Inter-Domain Routing)."
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "db_password_secret_name" {
  type = string
}

variable "rds_instance_class" {
  type = string
}

variable "allocated_storage" {
  type = string
}

variable "db_name" {
  type = string
  default = "testdb"
}

variable "db_username" {
  type = string
  default = "admin"
}

variable "engine_version" {
  type = string
  default = "8.0"
}
