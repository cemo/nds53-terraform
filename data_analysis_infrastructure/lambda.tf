data "archive_file" "kinesis2bq" {
  type        = "zip"
  source_dir  = "lambda/kinesis2bq"
  output_path = "lambda/kinesis2bq.zip"
}

resource "aws_lambda_function" "kinesis2bq" {
  filename         = "${data.archive_file.kinesis2bq.output_path}"
  function_name    = "${var.service_name}-${terraform.workspace}-kinesis2bq"
  role             = "${aws_iam_role.kinesis_lambda.arn}"
  handler          = "kinesis2bq.handler"
  source_code_hash = "${data.archive_file.kinesis2bq.output_base64sha256}"
  runtime          = "python2.7"
  timeout          = 60

  # NOTE: キーを含めて4KBまで
  environment {
    variables = {
      BQ_CREDENTIALS = "${data.aws_kms_ciphertext.bq_credentials.ciphertext_blob}"
      BQ_PROJECT     = "${var.google["project"]}"
      BQ_DATASET     = "${google_bigquery_dataset.main.dataset_id}"
      BQ_TABLE       = "${google_bigquery_table.main.table_id}"
    }
  }
}

resource "aws_lambda_event_source_mapping" "kinesis2bq" {
  batch_size        = 100 # default 100
  event_source_arn  = "${aws_kinesis_stream.main.arn}"
  function_name     = "${aws_lambda_function.kinesis2bq.arn}"
  starting_position = "TRIM_HORIZON"
}
