resource "aws_eip" "nat_eip" {
  vpc        = true
}

resource "aws_internet_gateway" "ig" {
  vpc_id = var.aws_vpc_id
}


resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = var.aws_subnet-public-1
  depends_on    = [aws_internet_gateway.ig]

}