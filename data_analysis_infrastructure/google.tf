provider "google" {
  credentials = "${file(var.google["credentials"])}"
  project     = "${var.google["project"]}"
  region      = "${var.google["region"]}"
}
