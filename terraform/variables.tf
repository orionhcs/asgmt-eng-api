variable "region" {
  default = "us-west-2"
  description = "AWS Region"
}

variable "remote_state_key" {}
variable "remote_state_bucket" {}


variable "app_name" {}
variable "app_env" {}

#variable "filename" {
#  description = "file name of the zip to be uploaded to the lambda function"
#}

variable "service_tag" {}