Module usage:

      module "github.com/UKHomeOffice/acp-tf-pool" {
        name            = "ingress"
        environment     = "dev"            # by default both Name and Env is added to the tags
        tags            = {
          Role = "ingress"
        }
        tables  = "${module.infra.routing_tables}"
        zones   = [ a_list_zones ]
        # You can specify the CIDR either by subnet_cidr or passing the var.network_mask and var.network_offtset which uses cidrsubnet
        subnet_cidr     = "10.100.0.0/24"
        # or
        network_mask    = 8                # assuming vpc 10.100/16 this would give 10.100.20.0/24
        network_offset  = 20               # will use the cidrsubnet function to calculate or use cidr
      }



## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| default_table | The default routing table, which overrides the per availability zones | `` | no |
| environment | An envionment name for the subnets i.e. prod, dev, ci etc | - | yes |
| name | A descriptive name for this subnets | - | yes |
| network_mask | The network mask which is applied when creating the subnets | `8` | no |
| network_offset | A network offset to generate the subnets from i.e. if mask = 8 and offset 100, it will create 10.40.10{1,2,3} | `` | no |
| subnet_cidr | The subnet cidr which you are creating, you can use this or the cidrsubnet() calculated by var.network_mask and var.network_offset | `` | no |
| tables | A map of availability zone to routing table id, so we can association subnets | `<map>` | no |
| tags | A map of cloud tags which added to the subnets, note Name, Env and KubernetesCluster are added by default | `<map>` | no |
| vpc_cidr | The VPC network cidr for this cluster, required if you are using var.network_mask and var.network_offset | `` | no |
| vpc_id | The VPC id where you want to create the cluster | - | yes |
| zones | A list of availability zones where you want to build the subnets | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| cidrs |  |
| subnets |  |

