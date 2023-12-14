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