#General variables
variable "aws_profile" {
  type    = string
  default = "default"
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

#General variables for envs and app
variable "app" {
  type    = string
  default = "app"
}

variable "env" {
  type    = string
  default = "env"
}

variable "name_container" {
  type    = string
  default = "container"
}

#Variables for module "initial_build"
variable "working_dir" {
  type    = string
  default = ""
}

variable "image_tag" {
  type    = string
  default = "latest"
}

#Variables for module "ecs_cluster"
variable "cidr_block" {
  description = "The CIDR block of the project"
  default     = "10.0.0.0/16"
}

variable "app_port" {
  description = "The application port"
  default     = 80
}

variable "taskdef_template" {
  default = "web_server.json.tpl"
}

variable "web_server_count" {
  description = "Number of web server containers to run"
  default     = 1
}

variable "web_server_fargate_cpu" {
  description = "Fargate instance CPU units to provision for web server (1 vCPU = 1024 CPU units)"
  default     = 256
}

variable "web_server_fargate_memory" {
  description = "Fargate instance memory to provision for web server (in MiB)"
  default     = 512
}

variable "github_oauth_token" {
  type    = string
  default = ""
}

variable "repo_url" {
  type    = string
  default = ""
}

variable "branch_pattern" {
  type    = string
  default = "^refs/heads/main$"
}

variable "git_trigger_event" {
  type    = string
  default = "PUSH"
}
