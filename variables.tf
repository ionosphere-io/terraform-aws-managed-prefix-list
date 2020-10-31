variable "region" {
    type = string
    description = "The AWS region to deploy to."
}

variable "tf_state" {
    type = string
    description = "The location of the Terraform state file."
    default = "1"
}

variable "lambda_memory_size" {
    type = number
    description = "The amount of memory, in MiB, allocated to the Lambda function."
    default = 256
}

variable "lambda_role_arn" {
    type = string
    description = "If set, the Lambda function deployed will use this role ARN instead of creating one."
    default = ""
}

variable "lambda_role_prefix" {
    type = string
    description = "The prefix to use for the role name."
    default = ""
}

variable "lambda_principal" {
    type = string
    description = "The name of the Lambda principal. Defaults to lambda.amazonaws.com. This may be different in isolated regions."
    default = "lambda.amazonaws.com"
}

variable "lambda_timeout" {
    type = number
    description = "The amount of time, in seconds, the Lambda function is allowed to run before being terminated."
    default = 300
}

locals {
    lambda_role_prefix = (var.lambda_role_prefix == "" ? "ManageAWSPrefixLists-${var.region}-" : var.lambda_role_prefix)
}