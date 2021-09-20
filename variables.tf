variable "name" {
  type    = string
  default = "main"
}

variable "namespace" {
  default = "default"
}

variable "keep_alive" {
  default = false
}

variable "cron_schedule" {
  default = "*/1 * * * 1-5"
}

variable "location" {
  default = "us-central1"
}

variable "extra_annotations" {
  default = {}
}

variable "domain_name" {
  type    = string
  default = ""
}


variable "environment_vars" {
  sensitive = true
  default   = {}
}

variable "min_replicas" {
  type    = number
  default = 1
}

variable "max_replicas" {
  type    = number
  default = 1
}

variable "port" {
  type    = number
  default = 3000
}

variable "image_url" {
  type = string
}

variable "requests" {
  type = object({
    memory = string
    cpu    = string
  })
  default = {
    memory = "50Mi"
    cpu    = "10m"
  }

}

variable "limits" {
  type = object({
    memory = string
    cpu    = string
  })
  default = {
    memory = "500Mi"
    cpu    = "250m"
  }

}

