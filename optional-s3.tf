variable "bucket_name" {
  description = "Name to use for the bucket. If null, will default to product."
  default     = null
  type        = string
}

variable "use_prefix" {
  description = "Create bucket with prefix instead of explicit name"
  default     = true
  type        = bool
}

variable "is_versioned" {
  description = "Is versioning enabled?"
  default     = true
  type        = bool
}

variable "acl" {
  description = "Canned ACL for the bucket"
  default     = "private"
  type        = string
}

variable "force_destroy" {
  description = "Allow destruction of an S3 bucket without clearing out the contents first"
  default     = false
  type        = bool
}

variable "cors_rules" {
  description = "CORS Rules"
  default     = []
  type = set(object({
    allowed_headers = list(string),
    allowed_methods = list(string),
    allowed_origins = list(string),
    expose_headers  = list(string),
    max_age_seconds = number
  }))
}

variable "lifecycle_rules" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default = [{
    id                                     = "default-lifecycle-rule",
    enabled                                = true,
    abort_incomplete_multipart_upload_days = 7,

    transition = [
      {
        days          = 7,
        storage_class = "INTELLIGENT_TIERING",
      }
    ]

    noncurrent_version_transition = [
      {
        days          = 30,
        storage_class = "GLACIER",
      }
    ]
  }]

  # Example:
  #
  # lifecycle_rules = [
  #   {
  #     id      = "log"
  #     enabled = true
  #
  #     prefix = "log/"
  #
  #     tags = {
  #       "rule"      = "log"
  #       "autoclean" = "true"
  #     }
  #
  #     transition = [
  #       {
  #         days          = 30
  #         storage_class = "STANDARD_IA" # or "ONEZONE_IA"
  #       },
  #       {
  #         days          = 60
  #         storage_class = "GLACIER"
  #       }
  #     ]
  #
  #     expiration = {
  #       days = 90
  #     }
  #   }
  # ]
}

variable "replication_configuration_set" {
  description = "Set of (single) replication that needs to be managed by this bucket. If empty, no replication takes place."
  default     = []
  type = set(object({
    role = string,
    rules = set(object({
      id                                           = string
      priority                                     = number
      status                                       = string
      destination_account_id                       = string
      destination_bucket                           = string
      destination_access_control_translation_owner = string
    }))
  }))
}

variable "replication_configuration_shortcut" {
  description = "Shorthand version of the configuration used in replication_configuration_set. Is overridden by replication_configuration_set if defined."
  default     = null
  type = object({
    destination_account_id = string
    destination_bucket     = string
  })
}

variable "replication_source" {
  description = "The account number and role for the source bucket in a replication configuration. Creates a bucket policy."
  default     = null
  type = object({
    account_id = string
    role       = string
  })
}


variable "bucket_policy" {
  description = "Policy to apply to the bucket. If null, one will be guessed based on surrounding functionality"
  default     = null
  type        = string
}

variable "allow_anonymous_vpce_access" {
  description = "Create bucket policy that allows anonymous VPCE access. If bucket_policy is defined, this will be ignored."
  default     = false
  type        = bool
}
