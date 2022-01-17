<!-- BEGIN_TF_DOCS -->
Module usage:

      module "github.com/UKHomeOffice/acp-tf-pool" {
        name            = "ingress"
        environment     = "dev"            # by default both Name and Env is added to the tags
        tags            = {
          Role = "ingress"
        }
        tables  = "${module.infra.routing\_tables}"
        zones   = [ a\_list\_zones ]
        # You can specify the CIDR either by subnet\_cidr or passing the var.network\_mask and var.network\_offtset which uses cidrsubnet
        subnet\_cidr     = "10.100.0.0/24"
        # or
        network\_mask    = 8                # assuming vpc 10.100/16 this would give 10.100.20.0/24
        network\_offset  = 20               # will use the cidrsubnet function to calculate or use cidr
      }

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.72.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route_table_association.default_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.zone_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_table"></a> [default\_table](#input\_default\_table) | The default routing table, which overrides the per availability zones | `string` | `""` | no |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | The DNS zone for the kubernetes cluster, due because the tools require the subnet is tagged with it | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | An envionment name for the subnets i.e. prod, dev, ci etc | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | A descriptive name for this subnets | `any` | n/a | yes |
| <a name="input_network_mask"></a> [network\_mask](#input\_network\_mask) | The network mask which is applied when creating the subnets | `number` | `8` | no |
| <a name="input_network_offset"></a> [network\_offset](#input\_network\_offset) | A network offset to generate the subnets from i.e. if mask = 8 and offset 100, it will create 10.40.10{1,2,3} | `string` | `""` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | The subnet cidr which you are creating, you can use this or the cidrsubnet() calculated by var.network\_mask and var.network\_offset | `string` | `""` | no |
| <a name="input_tables"></a> [tables](#input\_tables) | A map of availability zone to routing table id, so we can association subnets | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of cloud tags which added to the subnets, note Name, Env and KubernetesCluster are added by default | `map` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The VPC network cidr for this cluster, required if you are using var.network\_mask and var.network\_offset | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC id where you want to create the cluster | `any` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | A list of availability zones where you want to build the subnets | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cidrs"></a> [cidrs](#output\_cidrs) | A map of availability zone to cidr blocks |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | A map of availability zone to subnet id's |
<!-- END_TF_DOCS -->