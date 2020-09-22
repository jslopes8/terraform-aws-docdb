resource "random_id" "snapshot_identifier" {
    count = var.create ? 1 : 0

    byte_length = 4
    keepers = {
        id = var.docdb_name
    }
}
resource "aws_docdb_cluster_instance" "main" {
    count              = var.create ? var.instance_count : 0

    identifier          = "${var.docdb_name}-instance-${count.index}"
    cluster_identifier  = aws_docdb_cluster.main.0.id
    instance_class      = var.instance_class
    apply_immediately   = var.apply_immediately
    engine              = var.engine
    promotion_tier      = var.promotion_tier

    tags = var.default_tags
}
resource "aws_docdb_cluster" "main" {
    count = var.create ? 1 : 0

    cluster_identifier      = var.docdb_name
    engine                  = var.engine
    engine_version          = var.engine_version
    master_username         = var.master_username
    master_password         = var.master_password
    backup_retention_period = var.backup_retention_period
    preferred_backup_window = var.preferred_backup_window
    skip_final_snapshot     = var.skip_final_snapshot
    vpc_security_group_ids  = var.vpc_security_group_ids 

    db_subnet_group_name            = aws_docdb_subnet_group.main.0.id
    db_cluster_parameter_group_name = length(aws_docdb_cluster_parameter_group.main) > 0 ? aws_docdb_cluster_parameter_group.main.0.id : 0

    final_snapshot_identifier = "${lower(replace(var.docdb_name, " ", "-"))}-${random_id.snapshot_identifier.0.hex}-final-snapshot"

    tags = var.default_tags
}
resource "aws_docdb_subnet_group" "main" {
    count = var.create ? length(var.docdb_subnet_group) : 0

    name       = lookup(var.docdb_subnet_group[count.index], "name", null)
    subnet_ids = lookup(var.docdb_subnet_group[count.index], "subnet_ids", null)

    tags = merge(
        {
            "Name" = "${format("%s", var.docdb_name)}-Subnet-Group"
        },
        var.default_tags,
    )
}
resource "aws_docdb_cluster_parameter_group" "main" {
    count = var.create ? length(var.docdb_parameter_group) : 0

    name   = lookup(var.docdb_parameter_group.value, "name", null)
    family = lookup(var.docdb_parameter_group.value, "family", null)

    dynamic "parameter" {
        for_each = lookup(var.docdb_parameter_group.value, "parameter", null)
        content {
            apply_method    = lookup(parameter.value, "name", null)
            name            = lookup(parameter.value, "name", null)
            value           = lookup(parameter.value, "value", null)
        }
    }
}