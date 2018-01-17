resource "aws_instance" "manager" {
  ami                         = "ami-34171d57"
  availability_zone           = "${var.region}a"
  instance_type               = "${lookup(var.manager_instance_type, var.environment)}"
  security_groups             = ["${var.environment}-common"]
  key_name                    = "dexion-${var.environment}"
  disable_api_termination     = "false"
  ebs_optimized               = "${lookup(var.ebs_optimized, var.environment)}"
  monitoring                  = "true"

  root_block_device {
    volume_size = "${lookup(var.manager_root_disk_size, var.environment)}"
  }
  tags {
    Name         = "${var.environment}-manager"
    Environment  = "${var.environment}"
  }
  connection {
    user                = "centos"
    host                = "${self.public_ip}"
    private_key         = "${file("~/.ssh/dexion/id_rsa-dexion-${var.environment}")}"
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
