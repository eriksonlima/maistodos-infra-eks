
provider "aws" {
  region = local.region
  default_tags {
    tags = local.default_tags
  }
}

provider "kubernetes" {
  host                   = module.master.cluster_endpoint
  cluster_ca_certificate = base64decode(module.master.cluster_certificate)
  token                  = module.master.cluster_token
}

terraform {
  backend "s3" {
    bucket         = "maistodos-terraform-backend"
    dynamodb_table = "terraform_state"
    region         = "us-east-1"
    encrypt        = true
    key            = "eks/terraform-eks.tfstate"
  }
}

module "aws-auth" {
  source = "./modules/aws-auth"

  map_additional_iam_roles = var.map_additional_iam_roles
  map_additional_iam_users = var.map_additional_iam_users
}

data "aws_caller_identity" "self" {}
