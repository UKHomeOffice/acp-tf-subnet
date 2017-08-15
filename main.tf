/**
 * Module usage:
 *
 *       module "github.com/UKHomeOffice/acp-tf-pool" {
 *         name            = "ingress"
 *         environment     = "dev"            # by default both Name and Env is added to the tags
 *         tags            = {
 *           Role = "ingress"
 *         }
 *         tables  = "${module.infra.routing_tables}"
 *         zones   = [ a_list_zones ]
 *         # You can specify the CIDR either by subnet_cidr or passing the var.network_mask and var.network_offtset which uses cidrsubnet
 *         subnet_cidr     = "10.100.0.0/24"
 *         # or
 *         network_mask    = 8                # assuming vpc 10.100/16 this would give 10.100.20.0/24
 *         network_offset  = 20               # will use the cidrsubnet function to calculate or use cidr
 *       }
 *
 */

# Create the subnets used by the pool
resource "aws_subnet" "subnets" {
  count             = "${length(var.zones)}"
  vpc_id            = "${var.vpc_id}"
  availability_zone = "${var.zones[count.index]}"
  cidr_block        = "${var.subnet_cidr != "" ? var.subnet_cidr : cidrsubnet(var.vpc_cidr, var.network_mask, count.index + var.network_offset)}"

  tags = "${merge(var.tags,
    map("Name", format("%s-%s.%s.%s", var.name, var.zones[count.index], var.environment, var.dns_zone)),
    map("Env", var.environment),
    map("KubernetesCluster", format("%s.%s", var.environment, var.dns_zone)),
    map(format("kubernetes.io/cluster/%s.%s", var.environment, var.dns_zone), "shared"))}"
}

# Add the association to the routing table for this availability zone
resource "aws_route_table_association" "zone_routes" {
  count          = "${var.default_table == "" ? length(var.zones) : 0}"
  subnet_id      = "${element(aws_subnet.subnets.*.id, count.index)}"
  route_table_id = "${lookup(var.tables, element(aws_subnet.subnets.*.availability_zone, count.index))}"
}

# Add the route to the default routing table instead
resource "aws_route_table_association" "default_route" {
  count          = "${var.default_table != "" ? length(var.zones) : 0}"
  subnet_id      = "${element(aws_subnet.subnets.*.id, count.index)}"
  route_table_id = "${var.default_table}"
}
