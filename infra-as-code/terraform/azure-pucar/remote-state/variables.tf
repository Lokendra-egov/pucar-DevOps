variable "storage_container_name" {
  type = string
  default = "loki-dev-tfstate"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "location" {
  type = string
  default = "SouthIndia"
}

variable "resource_group" {
  type = string
  default = "loki-dev"
}

variable "subscription_id" {
  type = string
  default = "44e70aaa-6d39-441a-b282-352886e1ede7"
}
