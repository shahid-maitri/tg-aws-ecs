################
# Ubuntu AMI   #
################

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

################
# Key Pair     #
################

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "${var.environment}-${var.app}-${var.instance_name}-key"
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    Name = "${var.environment}-${var.app}-${var.instance_name}-key"
  }
}

################
# EC2 Instance #
################

resource "aws_instance" "this" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = element(var.public_subnets, 0)
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = aws_key_pair.this.key_name
  iam_instance_profile   = aws_iam_instance_profile.this.name

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = true
  }

  tags = {
    Name = "${var.environment}-${var.app}-${var.instance_name}"
  }
}
