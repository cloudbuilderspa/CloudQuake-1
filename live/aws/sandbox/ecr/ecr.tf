module "ecr" {
  source                     = "git::https://github.com/BastianCaceres-cloud/CloudInfraKit.git//aws/ecr?ref=main"
  ecr_repository_name       = "example-img-lambda-ahpp"
  ecr_image_tag_mutability  = "MUTABLE"
  ecr_scan_on_push          = true
}



module "ecr_arquetype_back" {
  source                     = "git::https://github.com/BastianCaceres-cloud/CloudInfraKit.git//aws/ecr?ref=main"
  ecr_repository_name       = "arquetype-back"
  ecr_image_tag_mutability  = "MUTABLE"
  ecr_scan_on_push          = true
}