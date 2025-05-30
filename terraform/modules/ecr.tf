resource "aws_ecr_repository" "hcl-hackathon-ecr" {
  name                 = "hcl-hackathon-devops-kamal-ecr"
  image_tag_mutability = "MUTABLE"


  image_scanning_configuration {
    scan_on_push = true
  }
}


