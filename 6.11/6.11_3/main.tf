provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_iam_user" "devs" {
  count = "${length(var.developer_names)}"
  name = "${element(var.developer_names,count.index )}"
}

resource "aws_iam_user" "devops" {
  count = "${length(var.devops_names)}"
  name = "${element(var.devops_names,count.index )}"
}

resource "aws_iam_group" "dev" {
  name = "developers"
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
  count = length(aws_iam_user.devs)
  user  = aws_iam_user.devs[count.index].name
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

resource "aws_iam_user_policy_attachment" "devops_policy_attachment_for_user" {
  count     = 1
  user      = aws_iam_user.devs[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "devops_policy_attachment" {
  group      = aws_iam_group.devops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}