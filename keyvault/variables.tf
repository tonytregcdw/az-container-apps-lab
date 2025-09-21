variable "rg" {}
variable "private-endpoint" {
    default = {}
}
variable "region" {}
variable "regioncode" {}
variable "code" {}
variable "tag_Department" {}
variable "tag_Environment" {}
variable "publicaccess" {}
variable "logging" {
  default = null
}
variable "entra_groups" {
  default = {}
}
variable "allow_public_ip" {
  default = []
}
variable "acl_default_action" {
  default = null
}
