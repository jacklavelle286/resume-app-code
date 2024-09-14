variable "source_ami" {
  type    = string
  default = ""
}

source "amazon-ebs" "portfolio_ami" {
  region               = "us-east-1"
  source_ami           = var.source_ami
  instance_type        = "t2.micro"
  iam_instance_profile = "ssm"
  ami_name             = "my-portfolio-ami-pipeline-image-{{timestamp}}"

  communicator         = "ssm"
}

build {
  sources = ["source.amazon-ebs.portfolio_ami"]

  provisioner "shell" {
    inline = [
      "sudo yum install -y amazon-ssm-agent",
      "sudo systemctl start amazon-ssm-agent",
      "sudo systemctl enable amazon-ssm-agent"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

  provisioner "file" {
    source      = "${var.template_dir}/website-files/"
    destination = "/var/www/html/"
  }

  provisioner "shell" {
    inline = [
      "sudo chown -R ec2-user:ec2-user /var/www/html",
      "sudo systemctl restart httpd"
    ]
  }
}
