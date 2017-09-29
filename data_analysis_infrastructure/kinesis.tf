resource "aws_kinesis_stream" "main" {
  name = "${var.service_name}-${terraform.workspace}"
  shard_count = 1
}
