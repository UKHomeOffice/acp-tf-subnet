variable "name" {
  description = "A descriptive name for this subnets"
}

variable "vpc_id" {
  description = "The VPC id where you want to create the cluster"
}

variable "vpc_cidr" {
  description = "The VPC network cidr for this cluster, required if you are using var.network_mask and var.network_offset"
  default     = ""
}

variable "environment" {
  description = "An envionment name for the subnets i.e. prod, dev, ci etc"
}

variable "dns_zone" {
  description = "The DNS zone for the kubernetes cluster, due because the tools require the subnet is tagged with it"
}

variable "subnet_cidr" {
  description = "The subnet cidr which you are creating, you can use this or the cidrsubnet() calculated by var.network_mask and var.network_offset"
  default     = ""
}

variable "network_offset" {
  description = "A network offset to generate the subnets from i.e. if mask = 8 and offset 100, it will create 10.40.10{1,2,3}"
  default     = ""
}

variable "tags" {
  description = "A map of cloud tags which added to the subnets, note Name, Env and KubernetesCluster are added by default"
  default     = {}
}

variable "zones" {
  description = "A list of availability zones where you want to build the subnets"
  type        = "list"
}

variable "default_table" {
  description = "The default routing table, which overrides the per availability zones"
  default     = ""
}

variable "ownership" {
  description = "Kubernetes cloud ownership tag, i.e. shared or owned"
  default     = "owned"
}

variable "tables" {
  description = "A map of availability zone to routing table id, so we can association subnets"
  type        = "map"
  default     = {}
}

variable "network_mask" {
  description = "The network mask which is applied when creating the subnets"
  default     = 8
}
