resource "aws_wafv2_web_acl" "todo_acl" {
  name        = "todo-web-acl"
  scope       = "REGIONAL"
  description = "Protect ALB with AWS WAF"
  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      sampled_requests_enabled = true
      cloudwatch_metrics_enabled = true
      metric_name = "commonRuleSet"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "webACL"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "todo-waf"
  }
}

resource "aws_wafv2_web_acl_association" "alb_waf_attach" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.todo_acl.arn
}
