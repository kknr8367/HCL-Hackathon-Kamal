resource "aws_security_group" "hcl_allow_tls" {
  name        = "hcl_allow_tls"
  description = "Allow TLS and HTTP inbound traffic, and all outbound traffic"
  vpc_id      = aws_vpc.hcl-hackathon-vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = {
    Name = "hcl_allow_tls"
  }
}
