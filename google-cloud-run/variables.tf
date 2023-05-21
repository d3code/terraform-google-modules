variable "project" {
  description = "The project_id of the project"
  type        = string
}

# -----------------------------------------------------

variable "name" {
  type    = string
}

variable "image" {
  type    = string
}

variable "region" {
  type    = string
}

variable "port" {
  type = number
}

variable "commit" {
  type    = string
}
