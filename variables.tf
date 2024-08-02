

variable "region" {
  type = string
  default = "us-east-1"
}

variable "account_name" {
  type = string
  description = "(Required) Account Name"
}

variable "root_email" {
  type = string
  description = "(Required) Account Email"
}

variable tags{
  type = map(string)
  description = "(Required) Tags for the resource"
}

variable "close_delete" {
  type = bool
  description = "Close Account on deletion"
  default = true
}

variable "gov_cloud" {
  type = bool
  description = "Gov Cloud Account"
  default = false
}

variable "parent_id" {
  type = string
  description = "(Required) Account Parent Organizational Unit"
}

variable monthly_budget {
  type = number
  default = 0
}

variable notification_email {
  type = string
  description = "Additional email where Budget Notifications are to be sent"
}
