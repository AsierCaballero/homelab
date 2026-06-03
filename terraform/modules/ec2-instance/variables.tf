variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "allowed_cidrs" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
