provider "aws" {
  region = "us-east-1"
}


resource "aws_security_group" "allow_rds_access" {
  name        = "allow_rds_access"
  description = "Allow EC2 to connect to RDS MySQL database"
  vpc_id      = "vpc-02bb196c472c19ef7"  # Replace with your VPC ID

  ingress {
    from_port   = 3306  # MySQL port
    to_port     = 3306
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

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-02bb196c472c19ef7"  # Replace with your VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows SSH from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ec2_http" {
  name        = "allow_ec2_http"
  description = "Allow EC2 instance HTTP access"
  vpc_id      = "vpc-02bb196c472c19ef7"  # Replace with your VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "app_instance" {
  ami           = "ami-01816d07b1128cd2d"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  key_name      = "todoKey"  # Replace with your SSH key name

  security_groups = [
    aws_security_group.allow_rds_access.name,
    aws_security_group.allow_ec2_http.name,
    aws_security_group.allow_ssh.name
  ]

  user_data = <<-EOT
              #install all package
              sudo yum update -y

              #install docker
              sudo yum install -y docker
              sudo service docker start
              sudo chkconfig docker on
              sudo usermod -aG docker ec2-user

              #install git
              sudo yum install git -y

              #aws cli
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install

              #install mysql client
              sudo yum update -y
              sudo yum install -y mysql

              EOT

  tags = {
    Name = "TodoAppEC2"
  }
}
