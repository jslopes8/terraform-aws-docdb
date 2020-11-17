output "endpoint" {
    value = aws_docdb_cluster.main.0.endpoint
}
output "reader_endpoint" {
    value = aws_docdb_cluster.main.0.reader_endpoint
}