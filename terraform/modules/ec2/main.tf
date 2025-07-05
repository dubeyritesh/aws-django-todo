data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu Official)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# resource "aws_instance" "app" {
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = "t3.micro"
#   subnet_id     = var.private_subnet_ids[count.index]
#   vpc_security_group_ids = [var.ec2_sg_id]
#   key_name               = var.key_name
#   associate_public_ip_address = true

#   tags = {
#     Name = "todo-app-ec2"
#   }

#   user_data = templatefile("${path.module}/user_data.sh.tpl", {
#     DB_NAME        = var.db_name
#     DB_USER        = var.db_user
#     DB_PASS        = var.db_password
#     DB_HOST        = var.db_host
#     STATIC_BUCKET  = var.static_bucket
#     GIT_REPO       = var.git_repo
#   })
# }

resource "aws_instance" "app" {
  count         = length(var.private_subnet_ids)
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.ec2_sg_id]
  key_name      = var.key_name

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    DB_NAME       = var.db_name
    DB_USER       = var.db_user
    DB_PASS       = var.db_password
    DB_HOST       = var.db_host
    STATIC_BUCKET = var.static_bucket
    GIT_REPO      = var.git_repo
  })

  tags = {
    Name = "todo-ec2-${count.index + 1}"
  }
}


