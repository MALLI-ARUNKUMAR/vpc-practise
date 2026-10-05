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


