terraform {
  backend "s3" {
    bucket = "tf-state"
    key    = "tf"
    region = "ap-southeast-1"
  }
}