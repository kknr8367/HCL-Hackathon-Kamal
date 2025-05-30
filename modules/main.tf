module "vpc" {
  source = "./vpc.tf"
}

module "security_group" {
  source = "./sg.tf"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./iam.tf"
}

module "ecr" {
  source = "./ecr.tf"
}

module "ecs_fargate" {
  source = "./ecs_fargate.tf"
  vpc_id         = module.vpc.vpc_id
  security_group = module.security_group.sg_id
  iam_role       = module.iam.ecs_task_execution_role_arn
  ecr_repo       = module.ecr.repository_url
}

module "cloudwatch" {
  source = "./terraform/module/cloudwatch"
  ecs_cluster_name = module.ecs_fargate.cluster_name
}