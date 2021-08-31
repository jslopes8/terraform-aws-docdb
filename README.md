# Terraform Module AWS DocumentDB (compativel com o MongoDB)

Terraform module irá provisionar os seguintes recursos:

* [DocumentDB Cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster)
* [DocumentDB Cluster Instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_instance)
* [DocumentDB Cluster Parameter Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster_parameter_group)
* [DocumentDB Subnet Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_subnet_group)

Como complemento, você ira precisar criar o Security Group e Secret Manager, que pode ser encontrado em;

* [Security Group](https://github.com/jslopes8/terraform-aws-networking-security-group.git)
* [Secret Manager](https://github.com/jslopes8/terraform-aws-secretmanager.git)

## Usage
`Caso de uso`: DocDB Cluster
```bash
module "cluster_docdb" {
    source = "git::https://github.com/jslopes8/terraform-aws-docdb.git?ref=v2.1"

    instance_count  = "1"
    docdb_name      = local.cluster_name
    instance_class  = "db.t3.medium"
    engine_version  = "3.6.0" 
    engine          = "docdb"
    master_username = local.master_username
    master_password = local.master_password

    vpc_security_group_ids  = [ module.cluster_docdb_sg.id ]
    docdb_subnet_group      = [{
        name = "${local.cluster_name}-subnet"
        subnet_ids = [
            tolist(data.aws_subnet_ids.sn_priv.ids)[0],
            tolist(data.aws_subnet_ids.sn_priv.ids)[1],
            tolist(data.aws_subnet_ids.sn_priv.ids)[2],
            tolist(data.aws_subnet_ids.sn_priv.ids)[3],
        ]
    }]

    default_tags = local.default_tags
}
```
## Requirements

| Name | Version|
|------|--------|
| aws | 3.* |
| terraform | 0.14.*| 

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Variables Inputs
| Name | Description | Required | Type | Default |
| ---- | ----------- | -------- | ---- | ------- |
| instance_count | Numerdo de instancias desajadas para integrar ao DocDB Cluster. | `yes` | `number` | `1` |
| docdb_name | O nome do cluster que será criado. | `yes` | `string` | ` ` |
| instance_class | O tipo de instancia que será usado. Para mais detalhes dos tipos suportados, [DocDB Scaling Instance](https://docs.aws.amazon.com/pt_br/documentdb/latest/developerguide/db-cluster-manage-performance.html#db-cluster-manage-scaling-instance) | `yes` | `string` | ` ` |
| apply_immediately | Especificação de qualquer mudança no DB, imediatamente ou na proxima janela de manutenção. | `no` | `bool` | `false` |
| engine | O nome da versão para usar o DocDB. Valor valido, `docdb`. | `yes` | `string` | `docdb` |
| promotion_tier | Default 0. Configuração de prioridade de failover no nível da instância. O reader com nível inferior tem prioridade mais alta para ser promovido para writer. | `no` | `number` | `0` |
| engine_version | A versão do database. | `yes` | `string` | ` ` |
| master_username | Usuario para o DB master user. | `yes` | `string` | ` ` |
| master_password | Senha para o DB master user. | `yes` | `string` | ` ` |
| backup_retention_period | Dias para reter o Backup. Default `1`. | `no` | `number` | `7` |
| preferred_backup_window | O intervalo diario durante o qual os backups automatizados são criados se os backups automatizados forem ativados usando o parâmetro BackupRetentionPeriod. Format `07:00-09:00`. | `no` | `string` | `07:00-09:00` |
| skip_final_snapshot | Determina a criação de um DB Snapshot antes de deletar o Cluster. | `no` | `bool` | `true` |
| vpc_security_group_ids | Lista de Ids dos Security Group associado ao cluster. | `yes` | `list` | `[ ]` |
| storage_encrypted | Especifique se o cluster será criptografado. | `no` | `bool` | `false` |
| enabled_cloudwatch_logs_exports | Lista dos tipos de logs que será expostado para o CloudWatch. Suportado, `audit` e `profiler`. | `no` | `list` | `[ ]` | 
| docdb_subnet_group | Subnet Group associado ao cluster. | `yes` | `list` | `[ ]` |
| docdb_parameter_group | Parameter Group associado ao cluster. | `no` | `list` | `[ ]` |
| maintenance_window | Janela de Manutenção. Sintax `Mon:00:00-Mon:03:00`. | `no` | `string` | `null` |
| default_tags | Um map de tags para atribuir na instance. | `yes` | `map` | `{ }` |

## Variable Outputs
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
| Name | Description |
| ---- | ----------- |
| endpoint | O endpoint de escrita do cluster. |
| reader_endpoint | O endpoint de leitura do cluster. |
