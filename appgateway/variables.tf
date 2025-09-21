#variables
variable "subnet" {
}
variable "rg" {
}
variable "region" {
}
variable "regioncode" {
}
variable "code" {
}
variable "tag_Department" {
}
variable "tag_Environment" {
}
variable "app-gateway" {
  default = {}
}
variable "sslcert" {
}
variable "certidentity" {
}
variable "pool_members" {
  default = {}
}
variable "waf_custom_rules" {
  default = null
}
variable "logging" {
  default = null
}
