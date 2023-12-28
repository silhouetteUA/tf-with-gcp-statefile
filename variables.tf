variable "GOOGLE_REGION" {
  type    = string
  default = "us-east1"
}

variable "GOOGLE_PROJECT" {
  type = string
}

variable "GKE_NUM_NODES" {
  type    = number
  default = 1
}

variable "ALGORITHM" {
  type    = string
  default = "ECDSA"
}

variable "ECDSA_CURVE" {
  type    = string
  default = "P256"
}

variable "GITHUB_OWNER" {
  type        = string
  description = "owner of github repo"
}

variable "FLUX_GITHUB_REPO" {
  type        = string
  description = "remote GH repository"
}

variable "GITHUB_TOKEN" {
  type = string
}

variable "TARGET_PATH" {
  type        = string
  description = "pth in GH repo for flux cd data"
  default     = "cluster"
}

variable "github_token" {
  sensitive = true
  type      = string
}

variable "github_org" {
  type    = string
  default = "silhouetteUA"
}

variable "github_repository" {
  type    = string
  default = "gitops-flux-sops"
}
################### LOCAL deployment STARTS HERE (localhost KIND cluster + FluxCD + repo reconciliation) ###################

# variable "local_kind_cluster_name" {
#   type    = string
#   default = "test-cluster"
# }

# # export TF_VAR_github_token=XXXXXXX   OR:   TF_VAR_my_variable="XXXXX" terraform apply
# variable "github_token" {
#   sensitive = true
#   type      = string
# }

# variable "github_org" {
#   type    = string
#   default = "silhouetteUA"
# }

# variable "github_repository" {
#   type    = string
#   default = "kbot"
# }
