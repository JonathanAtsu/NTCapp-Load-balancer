terraform {
  backend "s3" {
    bucket       = "week-10-app"
    key          = "week7P/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}