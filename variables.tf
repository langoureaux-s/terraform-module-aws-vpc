variable "vpc_name" {
  description = "Ressource group name"
}
variable "zones" {
  type = "list"
  description = "A list of availability zones in the region"
}

variable "network" {
  description = "The main network"
}
variable "subnets" {
  type = "list"
  description = "The list of subnet network"
}
variable "nat_subnet" {
  description = "The nat subnet to deploy vpn/router on it"
}
variable "secutiry_group_name" {
  description = "The admin security group name"
  default = "admin"
}

variable "tags" {
  type = "map"
}