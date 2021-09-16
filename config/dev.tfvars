#General variables
aws_profile = "default"
aws_region  = "eu-central-1"

#General variables for env and app
env            = "dev"
app            = "web"
name_container = "apache"

#Variables for module "initial_build"
image_tag = "0.0.1"

#Variables for module "ecs_cluster"
cidr_block                = "10.10.0.0/16"
app_port                  = 80
web_server_fargate_cpu    = 256
web_server_fargate_memory = 512
web_server_count          = 2

#Variables for module "codebuild"
repo_url          = ""
branch_pattern    = "^refs/heads/main$"
git_trigger_event = "PUSH"
