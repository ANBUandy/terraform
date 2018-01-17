resource "aws_instance" "manager" {
  ami                         = "ami-733cd111"
  availability_zone           = "${var.region}a"
  instance_type               = "${lookup(var.manager_instance_type, var.environment)}"
  security_groups             = ["${var.environment}-common"]
  key_name                    = "MintVM"
  disable_api_termination     = "false"
  ebs_optimized               = "${lookup(var.ebs_optimized, var.environment)}"
  monitoring                  = "false"

  root_block_device {
    volume_size = "${lookup(var.manager_root_disk_size, var.environment)}"
  }
  tags {
    Name         = "${var.environment}-manager"
    Environment  = "${var.environment}"
  }
  connection {
    user                = "ubuntu"
    host                = "${self.public_ip}"
    private_key         = "${file("~/.ssh/id_rsa")}"
  }
  provisioner "file" {
    source      = "../provision-scripts/bootstrap-ec2.sh" 
    destination = "/tmp/bootstrap-ec2.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo bash /tmp/bootstrap-ec2.sh -h manager.${var.environment}.localdomain -e ${var.environment}",
    ]
  }
}
