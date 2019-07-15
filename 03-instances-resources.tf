# Define Ubuntuserver inside the public subnet
resource "aws_instance" "ubuntu" {
   ami  = "${var.ami_id}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.tf-key-pair.id}"

   depends_on = ["aws_vpc.vpc"]
   subnet_id = "${aws_subnet.public-subnet.0.id}"

   depends_on = ["aws_security_group.sg_externo","aws_security_group.sg_interno"]
   vpc_security_group_ids = ["${aws_security_group.sg_externo.id}","${aws_security_group.sg_interno.id}"]

   associate_public_ip_address = true
   # source_dest_check = false
   user_data = "${file("./add-ssh-user.sh")}"

   tags {
    Name = "Ubuntu 1804 - ${var.cliente}"
    Owner = "${var.user}"
  }

  # lifecycle {
    # prevent_destroy = true
  # }
}
