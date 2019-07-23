variable "cliente" {
  default = "RDS-MySQL"
}
variable "region" {
  default = "us-east-2"
}
variable "zones" {
  description = "AZs to use"
  default = ["us-east-2a", "us-east-2c"]
  type = "list"
}
variable "aws_profile" {
  default = "emaster"
}
variable "vpc_range" {
  default = "10.19.0.0/21"  # 10.19.0.1 - 10.19.7.254
}
variable "pub_subnets_ranges" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  default = ["10.19.1.0/24", "10.19.3.0/24"]
  type = "list"
}
variable "priv_subnets_ranges" {
  description = "Subnet CIDRs for private subnets (length must match configured availability_zones)"
  default = ["10.19.2.0/24", "10.19.4.0/24"]
  type = "list"
}
variable "ami_id" {
  # default = "ami-02f706d959cedf892"  # Amazon Linux 2018.03.0 - us-east-2
  default = "ami-0986c2ac728528ac2"  # Ubuntu Server 18.04 LTS
}
variable "instance_type" {
  # default = "t2.medium"
  default = "t2.small"
}
variable "user" {
  default = "ubuntu"
}
variable "ssh_key" {
  default = "c:/Users/alessander.viana/alessander_rsa.pub"
}
