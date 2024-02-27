provider "aws" {
  region = "eu-north-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_iam_user" "developer" {
  count = "${length(var.developer_usernames)}"
  name = "${element(var.developer_usernames,count.index )}"
}

resource "aws_iam_user" "devops" {
  count = "${length(var.devops_usernames)}"
  name = "${element(var.devops_usernames,count.index )}"
}

resource "aws_iam_group" "dev" {
  name = "dev"
  path = "/"
}

resource "aws_iam_group" "devops" {
  name = "devops"
  path = "/"
}

resource "aws_iam_user_group_membership" "devops" {
  count = length(aws_iam_user.devops)
  user  = aws_iam_user.devops[count.index].name
  groups = [aws_iam_group.devops.name]
}

resource "aws_iam_user_group_membership" "dev" {
  count = length(aws_iam_user.developer)
  user  = aws_iam_user.developer[count.index].name
  groups = [aws_iam_group.dev.name]
}

resource "aws_iam_policy" "dev_policy" {
  name        = "DevEC2Policy"
  description = "Policy to allow stopping and starting EC2 instances"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:StopInstances",
        "ec2:StartInstances"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "dev_policy_attachment" {
  group      = aws_iam_group.dev.name
  policy_arn = aws_iam_policy.dev_policy.arn
}

resource "aws_iam_group_policy_attachment" "devops_policy_attachment" {
  group      = aws_iam_group.devops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}