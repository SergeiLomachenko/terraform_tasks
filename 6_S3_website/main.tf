provider "aws" {
    region = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_s3_bucket" "static_website" {
    bucket = "sergeybucket1501"
}

resource "aws_s3_bucket_acl" "sergey_acl" {
    bucket = aws_s3_bucket.static_website.id

    acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "task" {
    bucket = aws_s3_bucket.static_website.id
    
    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "error.html"
    }

    routing_rules = <<EOF
[{
      "Condition": {
        "KeyPrefixEquals": "docs/"
      },
      "Redirect": {
        "ReplaceKeyPrefixWith": ""
      }
}]
EOF
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.static_website.id
  key    = "index.html"

  source = "./website_bucket/s3-static-website/index.html" 
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.static_website.id
  key    = "error.html"

  source = "./website_bucket/s3-static-website/error.html"  
}
