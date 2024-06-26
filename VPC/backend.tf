terraform {
  backend "s3" {
    bucket = "naveen-kumar-backend-s3"
     key            = "naveen/terraform.tfstate"
    region         = "us-east-1"
    
  }
}
