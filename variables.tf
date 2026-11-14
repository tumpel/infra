variable "account_id" {
  type        = string
  description = "Cloudflare account that runs the control plane."
}

variable "hostname" {
  type        = string
  description = "Hostname the Worker serves; only the browser pages and the calls they make sit behind a Cloudflare Access login."
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
