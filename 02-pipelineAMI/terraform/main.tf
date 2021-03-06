provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "dev_img_kubernetes" {
  subnet_id                   = "${var.subnetId}"
  ami                         = "${var.amiId}"
  instance_type = "t2.large"
  associate_public_ip_address = true
  key_name                    = "${var.chave}"
  root_block_device {
    encrypted   = true
    volume_size = 30
  }
  tags = {
    Name = "dev-img-kubernetes"
  }
  vpc_security_group_ids = [aws_security_group.projetofinal_kubernetes2.id]
}

resource "aws_security_group" "projetofinal_kubernetes2" {
  name        = "projetofinal_kubernetes2"
  description = "projetofinal_kubernetes2 inbound traffic"
  vpc_id      = "${var.vpcId}"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
    {
      description      = "SSH from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids  = null,
      security_groups : null,
      self : null,
      description : "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "projetofinal_kubernetes2"
  }
}

variable "vpcId" {
  type        = string
  default = "vpc-0a08641ef0b17c6f9"
}

variable "subnetId" {
  type        = string
  default   = "subnet-019152f5bccbb831d"
}

variable "chave" {
  type        = string
  default = "key-private-turma3-dani-dev"
}

variable "amiId" {
  type        = string
  default = "ami-090006f29ecb2d79a"
}

# terraform refresh para mostrar o ssh
output "dev_img_kubernetes" {
  value = [
    "resource_id: ${aws_instance.dev_img_kubernetes.id}",
    "public_ip: ${aws_instance.dev_img_kubernetes.public_ip}",
    "public_dns: ${aws_instance.dev_img_kubernetes.public_dns}",
    "ssh -i /home/ubuntu/key-private-turma3-dani-dev.pem ubuntu@${aws_instance.dev_img_kubernetes.public_dns}"
  ]
}
