variable "create" {
    type = bool
    default = true
}
variable "docdb_name" {
    type = string
}
variable "engine" {
    type = string
    default = "docdb"
}
variable "master_username" {
    type = string
}
variable "master_password" {
    type = string
}
variable "backup_retention_period" {
    type = number
    default = "7"
}
variable "preferred_backup_window" {
    type = string
    default = "07:00-09:00"
}
variable "skip_final_snapshot" {
    type = bool
    default = true
}
variable "vpc_security_group_ids" {
    type = list
    default = []
}
variable "engine_version" {
    type = string
    default = ""
}
variable "docdb_subnet_group" {
    type = any
    default = []
}
variable "docdb_parameter_group" {
    type = any
    default = []
}
variable "default_tags" {
    type = map(string)
    default = {}
}
variable "apply_immediately" {
    type = bool
    default = false
}
variable "promotion_tier" {
    type = number
    default = "0"
}
variable "instance_count" {
    type = number
    default = "1"
}
variable "instance_class" {
    type = string
}
