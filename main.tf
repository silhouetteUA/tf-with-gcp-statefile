terraform {
  backend "gcs" {
    bucket = "edmitr-tf-bucket"
    prefix = "terraform/state_gke"
  }
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.2.1"
    }
    github = {
      source  = "integrations/github"
      version = ">=5.18.0"
    }
  }
}


module "gke_cluster" {
  source         = "github.com/silhouetteUA/tf-google-gke-cluster"
  GOOGLE_REGION  = var.GOOGLE_REGION
  GOOGLE_PROJECT = var.GOOGLE_PROJECT
  GKE_NUM_NODES  = var.GKE_NUM_NODES
}

provider "github" {
  owner = var.github_org
  token = var.github_token
}

resource "tls_private_key" "flux" {
  algorithm   = var.ALGORITHM
  ecdsa_curve = var.ECDSA_CURVE
}

resource "github_repository_deploy_key" "this" {
  title      = "Flux2"
  repository = var.github_repository
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
  depends_on = [tls_private_key.flux]
}

provider "flux" {
  kubernetes = {
    config_path = module.gke_cluster.kubeconfig
  }
  git = {
    url = "ssh://git@github.com/${var.github_org}/${var.github_repository}.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository_deploy_key.this, module.gke_cluster]
  path       = var.TARGET_PATH
}

module "gke-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  use_existing_k8s_sa = true
  name                = "kustomize-controller"
  namespace           = "flux-system"
  project_id          = var.GOOGLE_PROJECT
  cluster_name        = "main"
  location            = var.GOOGLE_REGION
  annotate_k8s_sa     = true
  roles               = ["roles/cloudkms.cryptoKeyEncrypterDecrypter"]
}

module "kms" {
  source          = "github.com/den-vasyliev/terraform-google-kms"
  project_id      = var.GOOGLE_PROJECT
  keyring         = "sops-flux"
  location        = "global"
  keys            = ["sops-keys-flux"]
  prevent_destroy = false
}


################### LOCAL deployment STARTS HERE (localhost KIND cluster + FluxCD + repo reconciliation) ###################

# terraform {
#   backend "gcs" {
#     bucket = "edmitr-tf-bucket"
#     prefix = "terraform/state"
#   }
#   required_providers {
#     kind = {
#       source  = "tehcyx/kind"
#       version = "0.2.1"
#     }
#     flux = {
#       source = "fluxcd/flux"
#       version = "1.2.1"
#     }
#     github = {
#       source  = "integrations/github"
#       version = ">=5.18.0"
#     }
#   }
# }


# provider "kind" {
# }

# resource "kind_cluster" "this" {
#   name = var.local_kind_cluster_name
# }

# provider "github" {
#   owner = var.github_org
#   token = var.github_token
# }

# resource "tls_private_key" "flux" {
#   algorithm   = "ECDSA"
#   ecdsa_curve = "P256"
# }

# resource "github_repository_deploy_key" "this" {
#   title      = "Flux"
#   repository = var.github_repository
#   key        = tls_private_key.flux.public_key_openssh
#   read_only  = "false"
# }

# provider "flux" {
#   kubernetes = {
#     host                   = kind_cluster.this.endpoint
#     client_certificate     = kind_cluster.this.client_certificate
#     client_key             = kind_cluster.this.client_key
#     cluster_ca_certificate = kind_cluster.this.cluster_ca_certificate
#   }
#   git = {
#     url = "ssh://git@github.com/${var.github_org}/${var.github_repository}.git"
#     ssh = {
#       username    = "git"
#       private_key = tls_private_key.flux.private_key_pem
#     }
#   }
# }

# resource "flux_bootstrap_git" "this" {
#   depends_on = [github_repository_deploy_key.this]
#   path       = "cluster/fluxcd-test"
# }
