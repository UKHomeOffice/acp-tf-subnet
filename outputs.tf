output "subnets" {
  description = "A map of availability zone to subnet id's"
  value       = "${zipmap(aws_subnet.subnets.*.availability_zone, aws_subnet.subnets.*.id)}"
}

output "cidrs" {
  description = "A map of availability zone to cidr blocks"
  value       = "${zipmap(aws_subnet.subnets.*.availability_zone, aws_subnet.subnets.*.cidr_block)}"
}
