#Import source credentials for github
resource "null_resource" "import_source_credentials" {

  triggers = {
    github_oauth_token = var.github_oauth_token
  }

  provisioner "local-exec" {
    command = <<EOF
      aws --region ${local.region} codebuild import-source-credentials \
                                                             --token ${var.github_oauth_token} \
                                                             --server-type GITHUB \
                                                             --auth-type PERSONAL_ACCESS_TOKEN
EOF
  }
}

#CodeBuild Project
resource "aws_codebuild_project" "project" {
  name          = local.codebuild_project_name
  description   = local.description
  build_timeout = "120"
  service_role  = aws_iam_role.role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "ENV"
      value = var.env
    }

  }

  source {
    buildspec           = var.build_spec_file
    type                = "GITHUB"
    location            = var.repo_url
    git_clone_depth     = 1
    report_build_status = "true"
  }

  depends_on = [null_resource.import_source_credentials]

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.subnets
    security_group_ids = [aws_security_group.codebuild_sg.id]
  }

}

#Webhook for CodeBuild project
resource "aws_codebuild_webhook" "develop_webhook" {
  project_name = aws_codebuild_project.project.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = var.git_trigger_event
    }

    filter {
      type    = "HEAD_REF"
      pattern = var.branch_pattern
    }
  }
}

#Security group for CodeBuild project
resource "aws_security_group" "codebuild_sg" {
  name        = "allow_vpc_connectivity-${var.app}-${var.env}-vpc"
  description = "Allow Codebuild connectivity to all the resources within our VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
