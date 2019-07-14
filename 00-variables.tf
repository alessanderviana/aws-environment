variable "region" {
  default = "us-east-2"
}
variable "aws_profile" {
  default = "default"
}
variable "vpc_range" {
  default = "10.19.0.0/21"
  # 10.19.0.1 - 10.19.7.254
}
variable "vpc_name" {
  default = "vpc-alessander"
}
variable "pub_subnet1_range" {
  default = "10.19.1.0/24"
}
variable "pub_subnet2_range" {
  default = "10.19.3.0/24"
}
variable "priv_subnet1_range" {
  default = "10.19.2.0/24"
}
variable "priv_subnet2_range" {
  default = "10.19.4.0/24"
}
variable "ami_id" {
  default = "ami-6a003c0f"
}
variable "user" {
  default = "ubuntu"
}
variable "ssh_key" {
  default = "~/terraform/alessander-tf.pub"
}
