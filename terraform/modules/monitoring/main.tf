# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "django_app" {
  name              = "/django/app"
  retention_in_days = 7

  tags = {
    Name = "django-log-group"
  }
}

# Alarm: EC2 CPU Utilization
resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  alarm_name          = "High-CPU-Utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70

  alarm_description   = "Alarm when CPU exceeds 70%"
  actions_enabled     = false

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# Alarm: ALB 5xx Error
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "ALB-5xx-Errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5

  alarm_description   = "Alarm when ALB returns too many 5xx errors"
  actions_enabled     = false

  dimensions = {
    LoadBalancer = var.alb_name
  }
}
