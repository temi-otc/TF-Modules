
variable "rg" {
  type = string
}
variable "location" {
  type = string
}
variable "vnet-name" {
  type = string
}
variable "subnet" {
  type = string
}

variable "nic" {
  type = string
}
variable "ipcon" {
  type = string
}
variable "vm-name" {
  type = string
}
variable "username" {
  type = string
  default = "temi"
}
variable "password" {
  type = string
  default = "Olanike@1973"
}
