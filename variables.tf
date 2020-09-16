variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the Spinnaker resources."
}

variable "spinnaker-auth-role-arn" {
  type        = string
  description = "ARN of the SpinnakerAuthRole from managing account"
}

variable "spinnaker-user-arn" {
  type        = string
  description = "ARN of the SpinnakerUser from managing account"
  default     = null
}

variable "ecr_repos" {
  type        = list(string)
  description = "List of ECR repos that the managing account will have access to."
  default     = []
}
