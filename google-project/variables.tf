variable "project_id" {
  description = "The project_id of the project"
  type        = string
}

variable "org_id" {
  description = "The project_id of the project"
  type        = string
}

variable "billing_account" {
  description = "The billing_account of the project"
  type        = string
}

variable "services" {
  description = "The services to enable for the project"
  type        = set(string)
}

