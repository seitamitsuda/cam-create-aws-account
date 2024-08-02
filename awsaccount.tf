terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_organizations_account" "account" {
  email = var.root_email
  name = var.account_name
  tags = var.tags
  parent_id = var.parent_id
  close_on_deletion=var.close_delete
  create_govcloud=var.gov_cloud
}

resource "aws_budgets_budget" "cost" {
  name  = join("-", ["SN-CAM-Monthly-Budget", aws_organizations_account.account.id])
  count = var.monthly_budget > 0 ? 1 : 0
  budget_type  = "COST"
  limit_amount = var.monthly_budget
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filter {
    name = "LinkedAccount"
    values = [
      aws_organizations_account.account.id
    ]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.root_email, var.notification_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 85
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.root_email, var.notification_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.root_email, var.notification_email]
  }
}
