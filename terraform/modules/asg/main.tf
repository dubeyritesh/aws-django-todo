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


resource "aws_launch_template" "this" {
  name_prefix   = "todo-launch-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile {
  name = var.instance_profile_name
}
  network_interfaces {
  associate_public_ip_address = true
  security_groups             = [var.ec2_sg_id]
}

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    DB_NAME       = var.db_name
    DB_USER       = var.db_user
    DB_PASS       = var.db_password
    DB_HOST       = var.db_host
    STATIC_BUCKET = var.static_bucket
    GIT_REPO      = var.git_repo
  }))
}

resource "aws_autoscaling_group" "this" {
  name                      = "todo-asg"
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  vpc_zone_identifier       = var.public_subnet_ids
  target_group_arns         = [var.target_group_arn]
  health_check_type         = "EC2"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "todo-asg-instance"
    propagate_at_launch = true
  }
}
