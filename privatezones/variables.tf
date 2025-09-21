variable "zone" {
}
variable "records" {
  default = {}
}
variable "rg" {
}
# variable "vnet" {
# }
variable "vnets" {
  type = map(object({
    id   = string
    name = string
  }))
}

variable "tag_Department" {
}
variable "tag_Environment" {
}
