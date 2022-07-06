resource "aws_s3_bucket" "bucket" {
  bucket   = var.s3-bucket-name
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = var.s3-bucket-acl
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.s3-bucket-versioning
  }
}

resource "aws_kms_key" "kmsKeyS3" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}


resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
 count = var.s3-bucket-encrypt == true ? 1 : 0

  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kmsKeyS3.arn 
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = var.s3-bucket-allow_access_list
    }

    actions = ["s3:ListBucket"]

    resources = [ "arn:aws:s3:::${var.s3-bucket-name}"]
    }
    statement {
    principals {
      type        = "AWS"
      identifiers = var.s3-bucket-allow_access_list
    }

    actions = ["s3:GetObject","s3:PutObject"]

    resources = ["arn:aws:s3:::${var.s3-bucket-name}/*"]
    }
}