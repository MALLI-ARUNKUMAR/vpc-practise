resource "aws_vpc_peering_connection" "public" {
  
  peer_vpc_id   = data.aws_vpc.default.id
  vpc_id        = var.vpc_cidr

  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}
