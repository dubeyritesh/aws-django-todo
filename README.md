# AWS Django To-Do App

This project includes:
- A Django To-Do app (app/)
- Terraform for AWS infra: VPC, EC2 ASG, ALB, RDS, S3, IAM, WAF (terraform/)

## Deploy

```bash
cd terraform
terraform init
terraform apply \
  -var="db_pass=<YOUR_DB_PASS>" \
  -var="static_bucket=todo-static-assets-12345" \
  -auto-approve
