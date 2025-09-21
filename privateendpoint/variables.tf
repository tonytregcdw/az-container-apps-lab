variable "name" {}
# variable "vnet" {}
variable "snet" {}
# variable "dnsrg" {}
variable "rg" {}
variable "dnszone" {}
# variable "sub-dns" {}
variable "resourceid" {}
variable "subresource" {}
variable "tag_Department" {}
variable "tag_Environment" {}
variable "code" {}
variable "regioncode" {}
variable "static_private_ip" {
  description = "Optional static private IP address for the private endpoint. If not set, dynamic allocation is used."
  type        = string
  default     = null
}