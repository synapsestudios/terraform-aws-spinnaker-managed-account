output "spinnaker-managed-arn" {
  description = "ARN of the SpinnakerManaged IAM role that the managing account assumes."
  value       = aws_iam_role.spinnaker-managed.arn
}
