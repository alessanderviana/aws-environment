# Define SSH key pair for our instances
resource "aws_key_pair" "tf-key-pair" {
  key_name = "key-pair-${var.cliente}"
  public_key = "${file("${var.ssh_key}")}"
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}

resource "aws_iam_user" "tf-iam-user" {
  name = "terraform"
  path = "/"
}

resource "aws_iam_user_ssh_key" "tf-key-user" {
  username   = "${aws_iam_user.tf-iam-user.name}"
  encoding   = "SSH"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5X3M1ngJgLxb94B8nU4cv/ODdq0DoR/joraTUCst9FL6bQP6WN11jBhZMmI/TrAjXeBj1whN2w3Ydy+aRHYEnpXNTj5tCOydivcRvIXRhPb6e9GFhaOjOwcvm6uTJLQEZCzOo0upXQMfO7DLnBbo5XzqeJoCouH/zpuRe46jauUsu/OtCCnj1jDowo8IBXp8SwZZEpAtJVh4yeGjFOcDah7Myc4IJharl6jT58he8PxNkP9STkComKrMAo02gp0BUzeyfcCNCULpp8qQVP9sso4u6sRrNOrsfLi1y4uLo1iFQvtrf9sGhFcGBNLDE/Js00rnkbB7pwpVVTX3X5+Wh"
}
