terraform {
    required_providers {
        aws = {
            source ="hashicorp/aws"
            version = "~>5.0"
        }
    }
}
provider "aws" {
    region ="us-east-1"
}


resource "aws_key_pair" "auth_key_pair" {
  key_name   = "auth_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1b6bPj01tFK6qTo6O6fCxNWqYKcj3iAvapNGLy4mb3WmeT3l9vAuAxmWHPVH0pS6K9s0Z/1M6tEIT9NbUy4M5yOQerWa5eaNxPooJtMLDRtE3VSvZEHHZ5L/4cque/JLI2BglMLucNbruJeQ3IULMMMuaLE+AcuYttNIxT8Ie/ok+7toBZPlpGMntJ+wOFV+HmNOJvtg+f9us5BjmfsliAJVmuAEomOzhMXZzqELC/N2FE7stnc8HXWj0KFwHYE5neEz2MKMCmAk7kAoc7R/30cEZxSW8U/4yRnCXawVrP7ZznlKKmlS+mVB+pICAnRwn5HOnwxS0WX8J0K0KuvauXApJhHaW3RYhMzW58oxnC97TJm4R92R3KHVT+ZoSM4LHbFzAo7E18fEPU5TGtZnOtrHj+rY+/VKfYzLcQvgWVHyugaSs/bpTMl/vdDe/N2Hp/1Hgmx2xMQAy3i6U0+Mhuk8qjg2Btz0fD8bswCGQcJgmJRCqm8cT9i3mZACbNoE= david@david-Latitude-E7470"
}

resource "aws_security_group" "create_auth_key_sg" {
  name        = "auth_key_sg"
  description = "This allows access to the instances"
  vpc_id      = "vpc-04d64f80071d1887e"

  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound traffic for auth-key-instance"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "Security group for auth-key-instance"
  }
}

resource "aws_instance" "auth-key-instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  count = "1"
  subnet_id     = "subnet-06e09c0e9342a167a"
  key_name      = aws_key_pair.auth_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.create_auth_key_sg.id]
  associate_public_ip_address = true
  user_data = file("/home/david/auth-do/auth_sg.sh")
  tags = {
    Name = "auth-key-instance"
  }
  connection {
    host = self.public_ip
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("auth_key")}"
  }
  provisioner "file"{
    source = "auth_sg.txt"
    destination ="/home/ubuntu/auth_sg.txt"
    when = create
  }

}



# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# provider "aws" {
#   region = "eu-west-2"  # Update with your desired AWS region
# }

# resource "aws_s3_bucket" "terrra-bucket" {
#   bucket = "terrra-bucket"  # Change to your desired bucket name

#   tags = {
#     Name = "MyBucket"
#   }
# }


# provider "aws" {
#   region = "us-east-1"  # Update with your desired AWS region
# }

# resource "aws_s3_bucket" "my_bucket" {
#   bucket = "my-unique-bucket-name"  # Change to your desired bucket name

#   tags = {
#     Name = "MyBucket"
#   }
# }

# resource "aws_s3_bucket_policy" "bucket_policy" {
#   bucket = aws_s3_bucket.my_bucket.id

#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Principal": "*",
#         "Action": [
#           "s3:GetObject"
#         ],
#         "Resource": "${aws_s3_bucket.my_bucket.arn}/*"
#       }
#     ]
#   })
# }


