variable "s3-region" {
  type = string
}

variable "s3-bucket-name" {
  type = string
  description = "Name of the S3 bucket"
}

variable "s3-bucket-acl" {
  type = string
  description = "ACL for the S3 bucket"
}

variable "s3-bucket-versioning" {
  type = string
  description = "Versioning state for the S3 bucket"
  default = "Disabled"
}

variable "s3-bucket-allow_access_list" {
  type = list(string)

}

variable "s3-bucket-encrypt" {
  type = bool
  description = "Encrypt bucket at rest"
  default = false
}