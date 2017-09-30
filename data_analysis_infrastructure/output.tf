output "Kinesis stream" {
  value = "${aws_kinesis_stream.main.name}"
}

output "BigQuery" {
  value = "${var.google["project"]}:${google_bigquery_dataset.main.dataset_id}:${google_bigquery_table.main.table_id}"
}
