variable "stage" {
  type        = string
  description = "Stage name; account-wide resources carry it so stages sit side by side."

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{1,15}$", var.stage))
    error_message = "Use 2 to 16 lower-case letters and digits, starting with a letter."
  }
}

variable "account_id" {
  type        = string
  description = "Cloudflare account that runs the control plane."
}

variable "zone_name" {
  type        = string
  default     = "tumpel.dev"
  description = "Cloudflare zone that carries every stage hostname; prod takes api, app and id directly under the zone, every other stage under <stage>.<zone>."
}

variable "otp_idp_id" {
  type        = string
  description = "Id of the account's one-time PIN Access login method."
}

variable "approver_emails" {
  type        = list(string)
  sensitive   = true
  description = "Emails the one-time PIN admits to the browser pages."

  validation {
    condition     = length(var.approver_emails) > 0 && alltrue([for email in var.approver_emails : can(regex("^[^@\\s]+@[^@\\s]+$", email))])
    error_message = "List at least one email address."
  }
}

variable "bootstrap_api_token" {
  type        = string
  sensitive   = true
  description = "Account-owned token holding Account API Tokens Write; mints the stage's R2 token, which the project token cannot."
}
