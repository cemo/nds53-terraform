provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "example" {
  ami = "ami-3bd3c45c"
  # ami = "ami-dfd0c7b8"
  # instance_type = "t2.nano"
  instance_type = "t2.micro"
}

resource "aws_eip" "example" {
  instance = "${aws_instance.example.id}"
}
