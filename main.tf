data "aws_availability_zones" "this" {}

resource "random_pet" "name" {}

resource "tls_private_key" "example" {
    algorithm = "RSA"
    rsa_bits  = 4096
  }

resource "aws_eip" "example" {
    vpc = true
  }

resource "aws_eip_association" "eip_assoc" {
    instance_id   = aws_instance.web.id
    allocation_id = aws_eip.example.id
  }
  
resource "aws_key_pair" "generated_key" {
    key_name   = var.key_name
    public_key = tls_private_key.example.public_key_openssh
  }
  

resource "aws_instance" "web" {
  
  availability_zone      = "${data.aws_availability_zones.this.names[0]}"
  ami                    = "${var.aws_east_ami}"
  instance_type          = "${var.aws_east_instance_type}"
  key_name               = aws_key_pair.generated_key.key_name
  user_data     = file("init-script.sh")

  vpc_security_group_ids = [aws_security_group.web-sg.id]

  tags = {
    Name = random_pet.name.id
  }
}

resource "aws_security_group" "web-sg" {
    name = "${random_pet.name.id}-sg"
    description = "Allow HTTP and SSH traffic via Terraform"

    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
  
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  resource "local_file" "cloud_pem" { 
    filename = "./lampkey.pem"
    content = tls_private_key.example.private_key_pem
  }