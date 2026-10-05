variable "project"{
    type = string
}

variable "environment"{
    type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}


variable "aws_vpc_tags"{
        default = {}
} 

variable "aws_gw_tags"{
    default = {}
}