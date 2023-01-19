
resource "aws_route_table" "private" {
  vpc_id = var.aws_vpc_id

}
resource "aws_route_table" "public" {
  vpc_id = var.aws_vpc_id

}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = var.aws_internet_gateway
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = var.destination_cidr_block
  nat_gateway_id         = var.aws_nat_gateway
}

resource "aws_route_table_association" "public" {
  subnet_id      =  var.aws_subnet-public-1
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  subnet_id      =  var.aws_subnet-private-1
  route_table_id = "${aws_route_table.private.id}"
}
