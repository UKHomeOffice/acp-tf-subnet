Module usage:

      module "github.com/UKHomeOffice/acp-tf-pool" {
        name            = "ingress"
        environment     = "dev"            # by default both Name and Env is added to the tags
        tags            = {
          Role = "ingress"
        }
        tables  = "${module.infra.routing_tables}"
        zones   = [ a_list_zones ]
        network_offset  = 20
      }

      Assuming eu-west-1{a,b,c} for zones and a vpc cidr of 10.80/16, this would create: 10.80.2{1,2,3}/24



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| default_table | The default routing table, which overrides the per availability zones | string | `` | no |
| environment | An envionment name for the subnets i.e. prod, dev, ci etc | string | - | yes |
| name | A descriptive name for this subnets | string | - | yes |
| network_mask | The network mask which is applied when creating the subnets | string | `8` | no |
| network_offset | A network offset to generate the subnets from i.e. if mask = 8 and offset 100, it will create 10.40.10{1,2,3} | string | - | yes |
| tables | A map of availability zone to routing table id, so we can association subnets | map | `<map>` | no |
| tags | A map of cloud tags which added to the subnets, note Name, Env and KubernetesCluster are added by default | string | `<map>` | no |
| vpc_cidr | The VPC network cidr for this cluster | string | - | yes |
| vpc_id | The VPC id where you want to create the cluster | string | - | yes |
| zones | A list of availability zones where you want to build the subnets | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| cidrs | A map of availability zone to cidr blocks |
| subnets | A map of availability zone to subnet id's |

