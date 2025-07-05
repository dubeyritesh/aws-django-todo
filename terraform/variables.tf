variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "db_name" {
  type        = string
  description = "Name of the database"
  default     = "tododb"
}

variable "db_user" {
  type        = string
  description = "Master username for RDS"
  default     = "admin"
}

variable "db_password" {
  type        = string
  description = "Master password for RDS"
  sensitive   = true
}

variable "static_bucket" {
  description = "S3 bucket name for static files"
  default     = "todo-static-assets-demo"
}
variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "static_bucket" {
  type        = string
  description = "S3 bucket name for static files"
}

variable "git_repo" {
  type        = string
  description = "GitHub repo URL to clone app"
  default     = "https://github.com/dubeyritesh/aws-django-todo.git"
}
