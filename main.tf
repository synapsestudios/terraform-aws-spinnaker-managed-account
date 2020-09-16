#########################
# Role - SpinnakerManaged
#########################
resource "aws_iam_role" "spinnaker-managed" {
  name               = "SpinnakerManaged"
  path               = "/spinnaker/"
  assume_role_policy = data.template_file.spinnaker-managed-policy.rendered
}

############################################
# Template - Policy Spinnaker Managed Policy
############################################
data "template_file" "spinnaker-managed-policy" {
  template = file("${path.module}/policies/SpinnakerRoleManaged.json")
  vars = {
    spinnaker-auth-role-arn = var.spinnaker-auth-role-arn
  }
}

#################################################
# Template - Policy Spinnaker User Managed Policy
#################################################
data "template_file" "spinnaker-user-managed-policy" {
  count = var.spinnaker-user-arn == null ? 0 : 1

  template = file("${path.module}/policies/SpinnakerUserManaged.json")
  vars = {
    spinnaker-auth-role-arn = var.spinnaker-user-arn
  }
}

####################
# Role - BaseIAMRole
####################
resource "aws_iam_role" "base-iam-role" {
  name               = "BaseIAMRole"
  assume_role_policy = file("${path.module}/policies/BaseIAMRole.json")
}

#####################################
# Policy Attachment - PowerUserAccess
#####################################
resource "aws_iam_role_policy_attachment" "power-user" {
  role       = aws_iam_role.spinnaker-managed.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

############################
# Policy - SpinnakerPassRole
############################
resource "aws_iam_policy" "spinnaker-pass-role" {
  name        = "SpinnakerPassRole"
  description = "Instance Profile to be used by any APP created by Spinnaker. Spinnaker has passRole access only to this instance Profile."
  policy      = file("${path.module}/policies/SpinnakerPassRole.json")
}

#######################################
# Policy Attachment - SpinnakerPassRole
#######################################
resource "aws_iam_role_policy_attachment" "spinnaker-pass-role" {
  role       = aws_iam_role.spinnaker-managed.name
  policy_arn = aws_iam_policy.spinnaker-pass-role.arn
}

########################################################
# Policy Attachment - AmazonEC2ContainerRegistryReadOnly
########################################################
resource "aws_iam_role_policy_attachment" "ecr-read-only" {
  role       = aws_iam_role.spinnaker-managed.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

###################################
# IAM Policy - ECR Read Only Access
###################################
data "aws_iam_policy_document" "ecrReadOnlyAccess" {
  statement {
    sid = "SpinnakerECRReadOnlyAccess"

    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchCheckLayerAvailability",
      "ecr:ListImages"
    ]

    principals {
      type        = "AWS"
      identifiers = [var.spinnaker-auth-role-arn]
    }
  }
}

resource "aws_ecr_repository_policy" "ecr_policy" {
  count = length(var.ecr_repos)

  repository = var.ecr_repos[count.index]
  policy     = data.aws_iam_policy_document.ecrReadOnlyAccess.json
}
