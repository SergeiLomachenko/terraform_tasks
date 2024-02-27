output "user_arns" {
  value = { for user in var.users : user => aws_iam_user.example_users[*].arn }
}

output "Dev_arn" {
  value = aws_iam_group.example_group_1
}

output "Devops_arn" {
  value = aws_iam_group.example_group_2
}