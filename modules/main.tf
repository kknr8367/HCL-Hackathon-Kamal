module "vpc" {
  source = "./vpc.tf"  # ✅ Directly referencing the Terraform file
}

module "security_group" {
  source = "./sg.tf"  # ✅ Directly referencing the Terraform file
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./iam.tf"  # ✅ Directly referencing the Terraform file
}

module "ecr" {
  source = "./ecr.tf"  # ✅ Directly referencing the Terraform file
}

module "ecs_fargate" {
  source         = "./ecs_fargate.tf"  # ✅ Directly referencing the Terraform file
  vpc_id         = module.vpc.vpc_id
  security_group = module.security_group.sg_id
  iam_role       = module.iam.ecs_task_execution_role_arn
  ecr_repo       = module.ecr.repository_url
}

module "cloudwatch" {
  source = "./cloudwatch.tf"  # ✅ Directly referencing the Terraform file
  ecs_cluster_name = module.ecs_fargate.cluster_name
}
