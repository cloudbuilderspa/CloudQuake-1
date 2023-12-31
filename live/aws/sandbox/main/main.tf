
#ELASTIC CONTAINER REGISTRY
module "ecr_componente1" {
  source = "git::https://github.com/BastianCaceres-cloud/CloudInfraKit.git//aws/ecr?ref=main"

  ecr_repository_name       = "ecr-componente1"
  ecr_image_tag_mutability  = "MUTABLE"
  ecr_scan_on_push          = true

}

module "ecr_componente2" {
  source = "git::https://github.com/BastianCaceres-cloud/CloudInfraKit.git//aws/ecr?ref=main"

  ecr_repository_name       = "ecr-componente2"
  ecr_image_tag_mutability  = "MUTABLE"
  ecr_scan_on_push          = true

}


# S3 BUCKET TERRAFORM STATE BACKEND
module "s3_tf_backend" {
  source = "git::https://github.com/BastianCaceres-cloud/CloudInfraKit.git//aws/s3_tf_backend?ref=main"
  bucket_name             = "infraestructure-bastian-002307"
  versioning              = false #true
  force_destroy           = false
  server_side_encryption  = false #true
}



# S3 BUCKET STORAGE GATEWAY
module "s3_storage_gateway" {
  source = "git::https://github.com/BastianCaceres-cloud/CloudInfraKit.git//aws/s3_storagegw?ref=main"
  bucket_name             = "storage-gateway-env-labs-657495"
  versioning              = false #true
  force_destroy           = false
  server_side_encryption  = false #true
  enable_lifecycle_rules  = false
}



##NEW ROUTE53
module "route53" {

  source = "git::https://github.com/BastianCaceres-cloud/CloudInfraKit.git//aws/rt53?ref=main"

  create_zone = true

  zone_name   = "nttdata-sandbox.cl"

  records = {
    www = {
      name    = "www.nttdata-sandbox.cl"
      type    = "A"
      ttl     = 300
      records = ["192.0.2.1"]
    }
  }

  tags = {
    terraform = "true"
    env = "labs"

  }

}




## CLOUDFRONT + S3 + OAI
module "cloudfront" {
  source = "git::https://github.com/BastianCaceres-cloud/CloudInfraKit.git//aws/cfront?ref=main"
  region                            = "us-east-1"
  bucket_name                       = "cloudfront-s3-oai-sandbox-ahpp-2023"
  bucket_acl                        = "private"
  cloudfront_comment                = "OAI for s3 bucket"
  cloudfront_default_ttl            = 3600
  cloudfront_max_ttl                = 86400
  cloudfront_min_ttl                = 0
  cloudfront_viewer_protocol_policy = "allow-all"
  cloudfront_geo_restriction_type   = "none"
}



# SIMPLE EMAIL SERVICES OUTPUT DNS RECORDS
module "ses" {
  source = "git::https://github.com/BastianCaceres-cloud/CloudInfraKit.git//aws/ses?ref=main"
  domain = "nttdata-sandbox.cl"
}

output "domain_identity_arn" {
  value = module.ses.domain_identity_arn
}

output "dkim_tokens" {
  value = module.ses.dkim_tokens
}






# MODULE SIMPLE QUEUE SERVICE

module "sqs" {
  source = "git::https://github.com/BastianCaceres-cloud/CloudInfraKit.git//aws/sqs?ref=main"

  region                     = "us-east-1"
  queue_name                 = "my-queue"
  delay_seconds              = 5
  max_message_size           = 256000
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 30
}





#ELASTICACHE REDIS
# MSK KAFKA
#OPENSEARCH
#EKS










##NEW ACM SSL REQUEST DNS VALIDATION
#REQUIRE DNS PROPAGATED

# module "acm" {
#   source = "git::https://github.com/BastianCaceres-cloud/CloudInfraKit.git//aws/acm?ref=main"

#   domain_name = "cloudbuilder.cl"
#   zone_id     = module.route53.zone_id
#   tags = {
#     terraform = "true"
#     environment = "labs"
#   }
#   validation_record_fqns   = module.route53.fqdns
#   validation_record_names  = module.route53.names

#   depends_on = [module.route53]
# }




#LAMBDA FUNCTION WITH ECR IMAGE
#REQUIRED ECR IMAGE PUSHED

# module "lambda" {
  # source = "git::https://github.com/BastianCaceres-cloud/CloudInfraKit.git//aws/lambda?ref=main"
#   region = "us-east-1"
#   lambda_function_name = "my-function"
#   docker_image_uri = "public.ecr.aws/poc-hello-world/hello-service:latest"

#   lambda_timeout    = 3
#   lambda_memory_size = 128
#   # lambda_entry_point = ["/lambda-entrypoint.sh"]

# }
