# variable "key_file" {
#     default = "./terraform-key.json"
# }

variable "project_id" {
  default = "iti-final-task"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "prefix" {
    default = "nagham"
}

variable "managed-subnet-ip-cidr" {
  default = "10.0.1.0/24"
}

variable "restricted-subnet-ip-cidr" {
  default = "10.0.2.0/24"
}