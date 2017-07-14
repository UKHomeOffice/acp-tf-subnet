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
 *         network_offset  = 20
 *       }
 *
 *       Assuming eu-west-1{a,b,c} for zones and a vpc cidr of 10.80/16, this would create: 10.80.2{1,2,3}/24
 *
 */

# Get the VPC for this environment
data "aws_vpc" "selected" {
  tags {
    Env  = "${var.environment}"
  }
}

# Create the subnets used by the pool
resource "aws_subnet" "subnets" {
  count             = "${length(var.zones)}"
  vpc_id            = "${data.aws_vpc.selected.id}"
  availability_zone = "${var.zones[count.index]}"
  cidr_block        = "${cidrsubnet(data.aws_vpc.selected.cidr_block, var.network_mask, count.index + var.network_offset)}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", format("%s", var.environment)), map("KubernetesCluster", format("%s", var.environment)) )}"
}

# Add the association to the routing table for this availability zone
resource "aws_route_table_association" "zone_routes" {
  count          = "${var.default_table == "" ? length(var.zones) : 0}"
  subnet_id      = "${element(aws_subnet.subnets.*.id, count.index)}"
  route_table_id = "${lookup(var.tables, element(aws_subnet.subnets.*.availability_zone, count.index))}"
}

# Add the route to the default routing table instead
resource "aws_route_table_association" "default_route" {
  count          = "${var.default_table != "" ? 1 : length(var.zones)}"
  subnet_id      = "${element(aws_subnet.subnets.*.id, count.index)}"
  route_table_id = "${var.default_table}"
}
