module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "my-eks-cluster-ahpp_sandbox-3"
  cluster_version = "1.27"
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      configuration_values = jsonencode({
        computeType = "Fargate"
      })

    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  }

  vpc_id                   = "vpc-08f7e81839d73a339"
  subnet_ids               = ["subnet-094726eea389c7f3a", "subnet-052e519657f5ae177", "subnet-02ab93862b4cedb2c"]
  control_plane_subnet_ids = ["subnet-094726eea389c7f3a", "subnet-052e519657f5ae177", "subnet-02ab93862b4cedb2c"]




  # Self Managed Node Group(s)
  # self_managed_node_group_defaults = {
  #   instance_type                          = "m6i.large"
  #   update_launch_template_default_version = true
  #   iam_role_additional_policies = {
  #     AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  #   }
  # }

  # self_managed_node_groups = {
  #   one = {
  #     name         = "mixed-1"
  #     max_size     = 5
  #     desired_size = 2

  #     use_mixed_instances_policy = true
  #     mixed_instances_policy = {
  #       instances_distribution = {
  #         on_demand_base_capacity                  = 0
  #         on_demand_percentage_above_base_capacity = 10
  #         spot_allocation_strategy                 = "capacity-optimized"
  #       }

  #       override = [
  #         {
  #           instance_type     = "m5.large"
  #           weighted_capacity = "1"
  #         },
  #         {
  #           instance_type     = "m6i.large"
  #           weighted_capacity = "2"
  #         },
  #       ]
  #     }
  #   }
  # }

  # EKS Managed Node Group(s)
  # eks_managed_node_group_defaults = {
  #   instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  # }

  # eks_managed_node_groups = {
  #   blue = {}
  #   green = {
  #     min_size     = 1
  #     max_size     = 10
  #     desired_size = 1

  #     instance_types = ["t3.large"]
  #     capacity_type  = "SPOT"
  #   }
  # }



  # Fargate Profile(s)
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        },
        {
          namespace = "kube-system"
        }
      ]
    },

  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::992927038462:role/my-eks-cluster-ahpp_sandbox-2_role"
      username = "eksadmin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::992927038462:role/my-eks-cluster-ahpp_sandbox-2_fargate_pod_execution_role"
      username = "eksadmin"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::992927038462:user/bzamora"
      username = "bzamora"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::992927038462:user/bcaceres"
      username = "bcaceres"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::992927038462:user/pipelines"
      username = "pipelines"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_accounts = [
    "992927038462",
  ]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}