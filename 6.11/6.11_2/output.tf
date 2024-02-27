output "user_arns" {
  value = concat(aws_iam_user.developer[*].arn, aws_iam_user.devops[*].arn)
}