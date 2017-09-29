resource "google_bigquery_dataset" "main" {
  dataset_id = "${var.service_name}_${terraform.workspace}" # only [0-9a-zA-Z_]
}

resource "google_bigquery_table" "main" {
  dataset_id = "${google_bigquery_dataset.main.dataset_id}"
  table_id   = "${var.bq["table_id"]}"
  schema     = "${file("bq/schema.json")}"
}
