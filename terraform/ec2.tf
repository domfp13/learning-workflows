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
resource "aws_security_group" "my_sg_public" {
  name        = "${var.project_name}-sg"
  description = "${var.project_name}-sg"
  vpc_id      = aws_vpc.workflow_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_sg_public.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-sg-ingress-rule-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_sg_public.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-sg-ingress-rule-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.my_sg_public.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-sg-ingress-rule-https"
  }
}

// Security Group
resource "aws_security_group" "my_sg_private" {
  name        = "${var.project_name}-sg-private"
  description = "${var.project_name}-sg-private"
  vpc_id      = aws_vpc.workflow_vpc.id

  tags = {
    Name = "${var.project_name}-sg-private"
  }
}

resource "aws_security_group_rule" "allow_all_from_my_sg" {
  security_group_id        = aws_security_group.my_sg_private.id
  from_port                = 22
  to_port                  = 22
  type                     = "ingress"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.my_sg_public.id // This is the security group that will allow traffic from the other public network
}


// Creating an EC2 instance
resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  key_name      = "bastion_public_key_pair"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [
    aws_security_group.my_sg_public.id
  ]

  tags = {
    Name  = "${var.project_name}-ec2-public"
    Owner = local.tags.Owner
  }
}

resource "aws_instance" "my_ec2_private" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  key_name      = "bastion_public_key_pair"
  subnet_id     = aws_subnet.private_subnet.id
  vpc_security_group_ids = [
    aws_security_group.my_sg_private.id
  ]

  tags = {
    Name  = "${var.project_name}-ec2-private"
    Owner = local.tags.Owner
  }
}
