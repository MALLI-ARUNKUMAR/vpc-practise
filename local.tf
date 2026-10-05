local{
    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = true
    }

    aws_vpc_final_tags =merge(
                        local.common_tags,
                        {
                            Name = "${var.project}-${var-environment}
                        },
                        var.aws_vpc_tags
    )
}