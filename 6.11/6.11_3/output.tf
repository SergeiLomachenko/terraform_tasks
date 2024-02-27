output "user_arns" {
  value = concat(aws_iam_user.devs[*].arn, aws_iam_user.devops[*].arn)
}