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


variable "public_subnet_cidr" {
    default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "final_public_subnet"{
    default = {}
}