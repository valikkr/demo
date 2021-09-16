Project in AWS with github and terraform

This project creates cloud AWS infrastructure based on ECS Fargate

Main config files of application placed in folder ./App

Main config files of infrastructure placed in ./Config/dev.tfvars

Terraform.tfstate file placed in S3 it can be changed in ./terraform.tf

Buildspec for Codebuild placed in ./Config/Buildspec.yml

Commands for build : terraform apply --var-file="./config/dev.tfvars" --var-file="./config/secrets.tfvars"

secrets.tfvars placed locally and not pushed in github in reason it contains git OAuth token and github repo link
Project have 4 modules and dependencies between modules , each next module depends of other modules that was already build. So build process looks like next:

1.ECR ( creates repo in AWS )

2.Init-build ( build first image using Makefile form ./App just for start ECS cluster )

3.ECS ( creates ECS fargate cluster and start it with first image )

4.CodeBuild ( creates code build in private network and wait PUSH in GitHub repo )

Logic of project : we make some changes in GitHub repo , CodeBuild have webhook and using this changes build new image with this changes , if image builds successfully CodeBuild using terraform applly new image on ECS Fargate cluster .
