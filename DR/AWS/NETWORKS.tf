

resource "aws_vpc" "main" {
  cidr_block = "${var.address_space}"

  tags {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "mgmt_subnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.mgmt_subnet}"

  tags {
    Name = "MGMT"
  }
}

resource "aws_subnet" "untrust_subnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.untrust_subnet}"
 
  tags {
    Name = "UNTRUST"
  }
}

resource "aws_subnet" "trust_subnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.trust_subnet}"

  tags {
    Name = "TRUST"
  }
}

resource "aws_subnet" "dmz_subnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.dmz_subnet}"

  tags {
    Name = "DMZ"
  }
}

resource "aws_subnet" "mm_subnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.mm_subnet}"
  
  tags {
    Name = "MM"
  }
}

resource "aws_subnet" "hs_subnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.hs_subnet}"
  
  tags {
    Name = "HS"
  }
}


