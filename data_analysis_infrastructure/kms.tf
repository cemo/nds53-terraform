resource "aws_kms_key" "main" {}

resource "aws_kms_alias" "main" {
  name          = "alias/${var.service_name}-${terraform.workspace}"
  target_key_id = "${aws_kms_key.main.key_id}"
}

data "aws_kms_ciphertext" "bq_credentials" {
  key_id    = "${aws_kms_key.main.id}"
  plaintext = "${file(var.bq["credentials"])}"
}
