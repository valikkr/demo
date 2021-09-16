
module "elastic_container_registry" {
  source         = "./modules/ecr"
  app            = var.app
  env            = var.env
  name_container = var.name_container
}

module "initial_build" {
  source         = "./modules/init-build"
  working_dir    = "${path.root}/app"
  image_tag      = var.image_tag
  app            = var.app
  env            = var.env
  name_container = var.name_container
}

module "ecs" {
  source                    = "./modules/ecs"
  cidr_block                = var.cidr_block
  aws_dns                   = true
  app_port                  = var.app_port
  taskdef_template          = "${path.root}/modules/ecs/web_server.json.tpl"
  web_server_count          = var.web_server_count
  web_server_fargate_cpu    = var.web_server_fargate_cpu
  web_server_fargate_memory = var.web_server_fargate_memory
  aws_ecr_repository_url    = module.elastic_container_registry.aws_ecr_repository_url
  image_tag                 = var.image_tag
  app                       = var.app
  env                       = var.env
  name_container            = var.name_container
}

module "codebuild" {
  source             = "./modules/codebuild"
  vpc_id             = module.ecs.vpc_id
  subnets            = module.ecs.private_subnet_ids
  github_oauth_token = var.github_oauth_token
  repo_url           = var.repo_url
  branch_pattern     = var.branch_pattern
  git_trigger_event  = var.git_trigger_event
  build_spec_file    = "${path.root}/config/buildspec.yml"
  app                = var.app
  env                = var.env
  name_container     = var.name_container
}
