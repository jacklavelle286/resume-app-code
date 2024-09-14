# Packer Template: packer-template.pkr.hcl

# Required plugins block
packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Variables
variable "source_ami" {
  type    = string
  default = ""
}

variable "template_dir" {
  type    = string
  default = ""
}

# Source block using amazon-ebs builder
source "amazon-ebs" "portfolio_ami" {
  # Communicator settings
  communicator  = "ssh"
  ssh_interface = "session_manager"
  ssh_username  = "ec2-user"

  # AWS settings
  region               = "us-east-1"
  source_ami           = var.source_ami
  instance_type        = "t2.micro"
  iam_instance_profile = "ssm"

  # AMI settings
  ami_name             = "my-portfolio-ami-pipeline-image-{{timestamp}}"
}

# Build block with provisioners
build {
  sources = ["source.amazon-ebs.portfolio_ami"]

  # Install SSM Agent (usually pre-installed on Amazon Linux 2)
  provisioner "shell" {
    inline = [
      "sudo yum install -y amazon-ssm-agent",
      "sudo systemctl start amazon-ssm-agent",
      "sudo systemctl enable amazon-ssm-agent"
    ]
  }

  # Update system and install Apache HTTP Server
  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

  # Upload website files to a temporary directory
  provisioner "file" {
    source      = "${var.template_dir}/website-files/"
    destination = "/home/ec2-user/temp_website_files/"
  }

  # Move files to /var/www/html/ and set ownership
  provisioner "shell" {
    inline = [
      "sudo cp -r /home/ec2-user/temp_website_files/* /var/www/html/",
      "sudo chown -R ec2-user:ec2-user /var/www/html",
      "sudo rm -rf /home/ec2-user/temp_website_files",
      "sudo systemctl restart httpd"
    ]
  }
}
