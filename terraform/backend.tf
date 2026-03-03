terraform {
  backend "s3" {
    bucket       = "umami-terraform-state-2026"
    key          = "eks/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}