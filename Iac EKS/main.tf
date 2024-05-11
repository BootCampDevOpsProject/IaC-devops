
# Variables locales a utilizar en los modulos VPC, EKS
# Nombre del EKS y región dónde sera creado
locals {
  name   = "eks-yuma-cluster"
  region = "us-east-1"

# Configuración de VPC CIDR y AZ 
  vpc_cidr = "10.123.0.0/16"
  azs      = ["us-east-1a", "us-east-1b"]

# Configuración de subnets
  public_subnets  = ["10.123.1.0/24", "10.123.2.0/24"]
  private_subnets = ["10.123.3.0/24", "10.123.4.0/24"]
  intra_subnets   = ["10.123.5.0/24", "10.123.6.0/24"]

# Tags del EKS
  tags = {
    cluster-name = local.name
    environtment = "PROD"
    manager      = "devops-teams"
  }
}

# Modulo de VPC que contiene los recursos para la creación de la VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

# Configuración del nombre y CIDR de la VPC definida en las variables locales
  name = local.name
  cidr = local.vpc_cidr

# Configuración de AZ, y subnets definida en las variables locales
  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets

# Habilitación de nat_gateway
  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
 
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

# Modulo de EKS que contiene los recursos para la creación del EKS 
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

# Coniguración del nombre y acceso publico del cluster
  cluster_name                   = local.name
  cluster_endpoint_public_access = true

# Configuración de lo addons a instalar en el EKS
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
# Addon necesario para el monitorio en CloudWatch
    amazon-cloudwatch-observability = {
      most_recent = true
    }
# Addon necesario para el monitorio en CloudWatch
    eks-pod-identity-agent = {
      most_recent = true
    }
  }
# Conifiguración de la VPC que utilizará el EKS con las variables locales definidas
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["m5.large", "m5.xlarge"]

    attach_cluster_primary_security_group = true
  }
# Configuración de los nodos a utilizar en el EKS
  eks_managed_node_groups = {
    dev-nodes = {
      min_size     = 1
      max_size     = 4
      desired_size = 1
# Tipo de instancia a utilizar en los nodos de EKS
      instance_types = ["t3.large", "t3.xlarge"]
      capacity_type  = "SPOT"
# Tags del nodo para DEV
      tags = {
        manager     = "devops_team"
        environment = "dev"
      }
# Configuración de taints de DEV para que solo se instalen pods en el nodo con el ambiente de DEV
      taints = [
        {
          key    = "dedicated"
          value  = "dev"
          effect = "NO_SCHEDULE"
        }
      ]
    },
    prod-nodes = {
      min_size     = 1
      max_size     = 4
      desired_size = 1
# Tipo de instancia a utilizar en los nodos de EKS
      instance_types = ["t3.large", "t3.xlarge"]
      capacity_type  = "SPOT"
# Tags del nodo para DPROD
      tags = {
        manager     = "devops_team"
        environment = "PROD"
      }
# Configuración de taints de PROD para que solo se instalen pods en el nodo con el ambiente de PROD
      taints = [
        {
          key    = "dedicated"
          value  = "prod"
          effect = "NO_SCHEDULE"
        }
      ]
    },
    default-nodes = {
      min_size     = 2
      max_size     = 4
      desired_size = 2
# Tipo de instancia a utilizar en los nodos de EKS
      instance_types = ["t3.xlarge"]
      capacity_type  = "SPOT"

      tags = {
        manager     = "devops_team"
        environment = "PROD"
      }
    }
  }

  tags = local.tags
}
