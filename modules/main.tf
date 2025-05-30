module "vpc" {
  source = "./modules/vpc"
}

module "security_group" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs_fargate" {
  source         = "./modules/ecs_fargate"
  vpc_id         = module.vpc.vpc_id
  security_group = module.security_group.sg_id
  iam_role       = module.iam.ecs_task_execution_role_arn
  ecr_repo       = module.ecr.repository_url
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  ecs_cluster_name = module.ecs_fargate.cluster_name
}
