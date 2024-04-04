// *************** key pair ***************
# resource "aws_key_pair" "mykey" {
#   key_name   = "mykey"
#   public_key = file("~/.ssh/id_rsa.pub")
# }

// *************** EC2 ***************

// Getting latest Amazon Linux AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

// Security Group
resource "aws_security_group" "my_sg" {
  name        = "${local.name}-sg"
  description = "${local.name}-sg"
  vpc_id      = aws_vpc.workflow_vpc.id

 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${local.name}-sg-ingress-rule-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${local.name}-sg-ingress-rule-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.my_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  
  tags = {
	Name = "${local.name}-sg-ingress-rule-https"
  }
}

// Creating an EC2 instance
resource "aws_instance" "my_ec2" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "bastion_public_key_pair"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [
	aws_security_group.my_sg.id
	]

  tags = {
    Name  = "${local.name}-ec2"
    Owner = local.tags.Owner
  }
}
