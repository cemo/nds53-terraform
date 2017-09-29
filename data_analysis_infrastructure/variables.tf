variable "aws" {
  default = {
    access_key = ""
    secret_key = ""
    region     = "ap-northeast-1"
  }
}

variable "google" {
  default = {
    credentials = "" # file path
    project     = ""
    region      = ""
  }
}

variable "service_name" {
  default = "nds53"
}

variable "bq" {
  default = {
    table_id = "myapp"
    credentials = "" # file path
  }
}
