# Set the AMI version here
variable "app_version" {
  type    = string
  default = "1.0.1"
}


# Set aws credentials from environment variables
variable "access_key" {
  type    = string
  default = "${env("AWS_ACCESS_KEY_ID")}"
}

variable "secret_key" {
  type      = string
  default   = "${env("AWS_SECRET_ACCESS_KEY")}"
  sensitive = true
}

variable "aws_instance_type" {
  default = "t2.micro"
}

# Add AMI short name (base or app name)
variable "ami_short_name" {
  type    = string
  default = "qwetu-app"
}

# Change if the APP version used is not the latest
variable "latest" {
  type    = string
  default = "true"
}

variable "aws_region" {
  type    = string
  default = "${env("AWS_DEFAULT_REGION")}"
}
