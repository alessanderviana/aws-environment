# https://hackernoon.com/manage-aws-vpc-as-infrastructure-as-code-with-terraform-55f2bdb3de2a
# https://nickcharlton.net/posts/terraform-aws-vpc.html

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_range}"

  enable_dns_hostnames = true
  # enable_dhcp_options              = true
  # dhcp_options_domain_name         = "service.dhcp"
  # dhcp_options_domain_name_servers = ["127.0.0.1", "192.168.20.2"]

  tags = {
    Owner       = "${var.user}"
    Name        = "${var.vpc_name}"
  }
}

# Define the public subnets
resource "aws_subnet" "pub-subnet-1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.pub_subnet1_range}"
  availability_zone = "${var.region}a"
  depends_on = ["aws_vpc.vpc"]

  tags {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "pub-subnet-2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.pub_subnet2_range}"
  availability_zone = "${var.region}b"
  depends_on = ["aws_vpc.vpc"]

  tags {
    Name = "Public Subnet 2"
  }
}

# Define the private subnets
resource "aws_subnet" "priv-subnet-1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.priv_subnet1_range}"
  availability_zone = "${var.region}a"
  depends_on = ["aws_vpc.vpc"]

  tags {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "priv-subnet-2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.priv_subnet2_range}"
  availability_zone = "${var.region}b"
  depends_on = ["aws_vpc.vpc"]

  tags {
    Name = "Private Subnet 2"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "tf-igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "VPC TF-IGW"
  }
}

# Define the route table
resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tf-igw.id}"
  }

  tags {
    Name = "Default RT"
  }
}

# Assign the route table to the public Subnets
resource "aws_route_table_association" "public-rt" {
  subnet_id = "${aws_subnet.pub_subnet1_range.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table_association" "public-rt" {
  subnet_id = "${aws_subnet.pub_subnet2_range.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

# Define the security group for public subnets
resource "aws_security_group" "sg_externo" {
  name = "sg_externo"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    cidr_blocks = ["35.224.10.153/32"]
  }

  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "udp"
    cidr_blocks = ["35.224.10.153/32"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # IP de casa (09/06/2018)
    cidr_blocks =  ["191.185.214.17/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    # prefix_list_ids = ["pl-12c4e678"]
  }

  vpc_id="${aws_vpc.vpc.id}"

  tags {
    Name = "SG Externo"
  }
}

# Define the security group for private subnet
resource "aws_security_group" "sg_interno"{
  name = "sg_interno"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.pub_subnet_range}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.pub_subnet_range}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.pub_subnet_range}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    # prefix_list_ids = ["pl-12c4e678"]
  }

  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "SG Interno"
  }
}
