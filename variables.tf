variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "banking-processor"
}

variable "bucket_name" {
  type    = string
  default = "uag-bigdata-banking-output-emi-v2"
}
