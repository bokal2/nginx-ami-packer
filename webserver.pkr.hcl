packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }

  }
}

# Set timestamp format
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "qwetu-app" {
  ami_name      = "${var.ami_short_name}-${var.app_version}"
  instance_type = var.aws_instance_type
  ssh_username  = "ubuntu"
  source_ami = "ami-0866a3c8686eaeeba"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "us-east-1"

  tags = {
    base_image    = "{{ .SourceAMIName }}"
    base_ami_id   = "{{ .SourceAMI }}"
    image_version = "${local.timestamp}"
    app_name      = "${var.ami_short_name}"
    app_version   = "${var.app_version}"
    latest        = "${var.latest}"
  }

  run_tags = {
    "qwetu:app"        = "qwetu-app-ami"
    "qwetu:infra:dtap" = "global"
    "Name"          = "qwetu-app-ami"
  }

}

build {
  name = "Qwetu App AMI"
  sources = [
    "source.amazon-ebs.qwetu-app"
  ]

  provisioner "ansible" {
    user                   = "ubuntu"
    playbook_file          = "./ansible/nginx-playbook.yml"
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
