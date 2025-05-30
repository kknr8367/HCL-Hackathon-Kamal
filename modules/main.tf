module "vpc" {
  source = "./vpc"  
}

module "security_group" {
  source = "./sg"  
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./iam"  
}

module "sg" {
  source = "./sg"  
}

module "ecr" {
  source = "./ecr"  
}

module "ecs_fargate" {
  source         = "./ecs_fargate"  
  vpc_id         = module.vpc.vpc_id
  security_group = module.security_group.sg_id
  iam_role       = module.iam.ecs_task_execution_role_arn
  ecr_repo       = module.ecr.repository_url
}

module "cloudwatch" {
  source = "./cloudwatch"  # ✅ Fixed module path
  ecs_cluster_name = module.ecs_fargate.cluster_name
}
