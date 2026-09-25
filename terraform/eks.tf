module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.project_name
  kubernetes_version = "1.33"

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnets

  endpoint_public_access  = true
  endpoint_private_access = true

  enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  addons = {
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }

    eks-pod-identity-agent = {
      most_recent    = true
      before_compute = true
    }

    coredns = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    main = {
      name = "${var.project_name}-nodes"

      subnet_ids = module.vpc.private_subnets

      min_size     = 2
      max_size     = 5
      desired_size = 2

      instance_types = ["t3.small"]

      capacity_type = "ON_DEMAND"

      associate_public_ip_address = false

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 1
        instance_metadata_tags      = "disabled"
      }

      tags = {
        Name        = "${var.project_name}-node"
        Environment = var.environment
        Project     = var.project_name
      }
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
