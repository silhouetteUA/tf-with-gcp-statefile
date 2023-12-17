# variable "GOOGLE_REGION" {
#   type    = string
#   default = "us-east1"
# }

# variable "GOOGLE_PROJECT" {
#   type = string
# }

# variable "GKE_NUM_NODES" {
#   type    = number
#   default = 1
# }

# LOCAL deployment STARTS HERE (localhost KIND cluster + FluxCD + repo reconciliation)

variable "local_kind_cluster_name" {
  type    = string
  default = "test-cluster"
}

# export TF_VAR_github_token=XXXXXXX   OR:   TF_VAR_my_variable="XXXXX" terraform apply
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
  default = "kbot"
}