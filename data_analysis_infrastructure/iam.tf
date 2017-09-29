resource "aws_iam_role" "kinesis_lambda" {
  name               = "${var.service_name}-${terraform.workspace}-kinesis_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.kinesis_lambda_assume_role_policy.json}"
}

data "aws_iam_policy_document" "kinesis_lambda_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "kinesis_lambda" {
  name   = "${var.service_name}-${terraform.workspace}-kinesis_lambda"
  role   = "${aws_iam_role.kinesis_lambda.id}"
  policy = "${data.aws_iam_policy_document.kinesis_lambda_role_policy.json}"
}

data "aws_iam_policy_document" "kinesis_lambda_role_policy" {
  statement {
    actions   = ["kinesis:*"]
    resources = ["${aws_kinesis_stream.main.arn}"]
  }
  statement {
    actions   = ["kms:Decrypt"]
    resources = ["${aws_kms_key.main.arn}"]
  }
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

