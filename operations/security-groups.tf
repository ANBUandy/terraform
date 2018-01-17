resource "aws_security_group" "common" {
  name   = "${var.environment}-common"
  ingress {
    from_port   = 0
    to_port     = 8
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] /* Open for 3rd parties. Secure via SFTP only shells, denyhosts, etc */
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-common"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "web" {
  name   = "${var.environment}-web"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/12"]
  }
  tags {
    Name        = "${var.environment}-web"
    Environment = "${var.environment}"
  }
}

