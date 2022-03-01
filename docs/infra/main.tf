terraform {
  backend "gcs" {
    prefix  = "terraform/docs"
  }
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "useast1"
  region = "us-east-1"
}

resource "aws_s3_bucket" "docs-logs" {
  bucket = "${var.site_name}-site-logs"
  acl = "log-delivery-write"
}

data "template_file" "bucket_policy" {
  template = file("frontend-policy.json")
  vars = {
    origin_access_identity_arn = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
    bucket = var.site_name
  }
}

data "template_file" "www_bucket_policy" {
  template = file("frontend-policy.json")
  vars = {
    origin_access_identity_arn = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
    bucket = "www.${var.site_name}"
  }
}

resource "aws_s3_bucket" "docs-archive" {
  bucket = "${var.site_name}-archive"
}

resource "aws_s3_bucket_object" "docs-archive" {
  for_each = fileset("../.vuepress/dist/", "**")

  key   = "${var.frontend_dist_name}/${each.value}"
  bucket = aws_s3_bucket.docs-archive.id
  source = "../.vuepress/dist/${each.value}"
}

resource "aws_s3_bucket" "docs" {
  bucket = var.site_name
  acl    = "public-read"
  policy = data.template_file.bucket_policy.rendered

  logging {
    target_bucket = aws_s3_bucket.docs-logs.bucket
    target_prefix = "${var.site_name}/"
  }

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket" "www-docs" {
  bucket = "www.${var.site_name}"
  acl    = "public-read"
  policy = data.template_file.www_bucket_policy.rendered

  website {
    redirect_all_requests_to = var.site_name
  }
}

resource "aws_acm_certificate" "cert" {
  provider = aws.useast1
  domain_name = var.site_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "www_cert" {
  provider = aws.useast1
  domain_name = "www.${var.site_name}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cloudfront origin access identity"
}

resource "aws_cloudfront_distribution" "docs_cdn" {
  enabled      = true
  price_class  = "PriceClass_100"
  http_version = "http1.1"
  aliases = [var.site_name]

  origin {
    origin_id   = "origin-bucket-${aws_s3_bucket.docs.id}"
    domain_name = aws_s3_bucket.docs.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  custom_error_response {
    error_code = 404
    response_code = 404
    response_page_path = "/index.html"
  }

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = "origin-bucket-${aws_s3_bucket.docs.id}"

    min_ttl          = "0"
    default_ttl      = "300"                                              //3600
    max_ttl          = "1200"                                             //86400

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_distribution" "www_website_cdn" {
  enabled      = true
  price_class  = "PriceClass_100"
  http_version = "http1.1"
  aliases = ["www.${var.site_name}"]

  origin {
    origin_id   = "origin-bucket-${aws_s3_bucket.www-docs.id}"
    domain_name = aws_s3_bucket.www-docs.website_endpoint

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = "origin-bucket-${aws_s3_bucket.www-docs.id}"

    min_ttl          = "0"
    default_ttl      = "300"                                              //3600
    max_ttl          = "1200"                                             //86400

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.www_cert.arn
    ssl_support_method       = "sni-only"
  }
}
