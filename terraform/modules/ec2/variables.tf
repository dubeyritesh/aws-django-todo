variable "public_subnet_id" {
  type        = string
  description = "Public subnet ID"
}

variable "ec2_sg_id" {
  type        = string
  description = "EC2 security group ID"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_host" {
  type = string
}

variable "static_bucket" {
  type = string
}

variable "git_repo" {
  type = string
}
