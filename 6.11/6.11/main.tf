provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_iam_group" "example_group_1" {
    name = var.devgroup
}

resource "aws_iam_group" "example_group_2" {
    name = var.devopsgroup
}

resource "aws_iam_user" "example_users" {
  count = length(var.users)

  name = var.users[count.index]
}

resource "aws_iam_user_group_membership" "example_group_membership" {
  for_each = { for user_index, user in var.users : user_index => user }

  user  = aws_iam_user.example_users[index(var.users, each.value)].name
  groups = [aws_iam_group.example_group_1.name]
}

resource "aws_iam_group_policy_attachment" "group1_policy" {
  group      = aws_iam_group.example_group_1.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2StopStart"
}

resource "aws_iam_group_policy_attachment" "group2_policy" {
  group      = aws_iam_group.example_group_2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
