resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = local.aws_vpc_final_tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = local.gw_final_tags
  }
  resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true # Makes it a public subnet

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
    },

    var.final_public_subnet

  )
}


  resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = local.az_names[count.index]
  
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
    },

    var.final_private_subnet

  )
}


  resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.database_subnet_cidr[count.index]
  availability_zone       = local.az_names[count.index]
 

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
    },

    var.final_database_subnet

  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.common_tags,
        {
          Name = "${var.project}-${var.environment}-public"
        },
        var.public_route_table
  )
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.common_tags,
        {
          Name = "${var.project}-${var.environment}-private"
        },
        var.private_route_table
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.common_tags,
        {
          Name = "${var.project}-${var.environment}-database"
        },
        var.database_route_table
  )
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_eip" "elastic" {
  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}"
    },
    var.elastic_tags
    
  )
  
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.elastic.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-nat"
    },
    var.nat_tags
  )

  depends_on = [aws_internet_gateway.gw]
}
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id =  aws_nat_gateway.nat.id
}
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id =  aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}




