terraform {
  backend "s3" {
    bucket = "cloud-mastery-tfstate-bucket-005008919446"
    key    = "project-hub-eks/terraform.tfstate"
    region = "us-east-1"
  }
}
