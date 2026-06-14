variable "role_name" {
  type        = string
  description = "Name of the IAM role"
}

variable "path" {
  type        = string
  description = "Path under which to create the role"
  default     = "/"
}

variable "assume_role_policy" {
  type        = string
  description = "JSON trust policy document for the role"
}

variable "managed_policy_arns" {
  type        = list(string)
  description = "List of managed policy ARNs to attach to the role"
  default     = []
}

variable "inline_policies" {
  type        = map(string)
  description = "Map of inline policy name to JSON policy document"
  default     = {}
}

variable "permissions_boundary" {
  type        = string
  description = "ARN of the policy used to set the permissions boundary"
  default     = null
}

variable "max_session_duration" {
  type        = number
  description = "Maximum session duration (in seconds) for the role"
  default     = 3600
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the role"
  default     = {}
}
