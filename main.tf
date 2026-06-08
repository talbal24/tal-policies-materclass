terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

variable "database_version" {
  type    = string
  default = "v1"
}

variable "app_version" {
  type    = string
  default = "v1"
}

# PROTECTED: changing this resource requires approval from the DBA team.
# Bump database_version (v1 -> v2) to trigger a change in the demo.
resource "null_resource" "database" {
  triggers = {
    version = var.database_version
  }
}

# NOT PROTECTED: anyone can change this and any deployer can approve.
resource "null_resource" "app" {
  triggers = {
    version = var.app_version
  }
}
