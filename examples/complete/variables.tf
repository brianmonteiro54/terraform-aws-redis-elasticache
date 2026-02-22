variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the ElastiCache subnet group (min 2, different AZs)"
  type        = list(string)
}

variable "auth_token" {
  description = "Redis AUTH token (min 16 chars, max 128 chars). Store in SSM Parameter Store or Secrets Manager."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.auth_token) >= 16 && length(var.auth_token) <= 128
    error_message = "Auth token must be between 16 and 128 characters."
  }
}
