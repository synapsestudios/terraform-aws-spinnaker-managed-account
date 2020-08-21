# AWS Spinnaker Managed Account

This module creates the necessary IAM roles and policies to allow a clients account to be managed by a Spinnaker Managing Account (SynapseStudios).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.6 |
| aws | ~> 2.53 |
| template | ~> 2.1 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.53 |
| template | ~> 2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| spinnaker-auth-role-arn | ARN of the SpinnakerAuthRole from managing account | `string` | n/a | yes |
| tags | A mapping of tags to assign to the Spinnaker resources. | `map(string)` | n/a | yes |
| ecr\_repos | List of ECR repos that the managing account will have access to. | `list(string)` | `[]` | no |
| spinnaker-user-arn | ARN of the SpinnakerUser from managing account | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| spinnaker-managed-arn | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->