variable "env" {
  type = string
  default = "dev"
  description = "The value of environment"
}

variable "vpc_cidr_block" {
  description = "CIDR (Classless Inter-Domain Routing)."
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
    description = "Project name."
    type        = string
    default     = "cw"
}
