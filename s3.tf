# -----------------------
# S3
# -----------------------

resource "random_string" "s3_unique_key" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_s3_bucket" "s3_static_bucket" {
  bucket = "${var.project}-${var.environment}-${random_string.s3_unique_key.result}"
  versioning {
    enabled = false
  }
}


resource "aws_s3_bucket" "s3_deploy_bucket" {
  bucket = "${var.project}-${var.environment}-deploy-${random_string.s3_unique_key.result}"
  versioning {
    enabled = false
  }
}

resource "aws_s3_bucket_public_access_block" "s3_static_bucket" {
  bucket                  = aws_s3_bucket.s3_static_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = false
  depends_on = [
    aws_s3_bucket.s3_static_bucket
  ]
}

resource "aws_s3_bucket_public_access_block" "s3_deploy_bucket" {
  bucket                  = aws_s3_bucket.s3_deploy_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on = [
    aws_s3_bucket.s3_static_bucket
  ]
}

resource "aws_s3_bucket_policy" "s3_static_bucket" {
  bucket = aws_s3_bucket.s3_static_bucket.id
  policy = data.aws_iam_policy_document.s3_static_bucket.json
}

data "aws_iam_policy_document" "s3_static_bucket" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.s3_static_bucket.arn}/*"
    ]
    principals {
      type = "AWS"
      identifiers = [
        "${aws_iam_role.app_iam_role.arn}"
      ]
    }
  }
}

data "aws_iam_policy_document" "s3_deploy_bucket" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.s3_deploy_bucket.arn}/*"
    ]
    principals {
      type = "AWS"
      identifiers = [
        "${aws_iam_role.app_iam_role.arn}"
      ]
    }
  }
}