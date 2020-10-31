# terraform-aws-managed-prefix-list
This module deploys a Lambda function to your AWS account that automatically creates and updates a set of
[managed prefix lists](https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html) associated with ranges of IP
addresses associated with AWS services.

## Usage
```terraform
module "managed-prefix-list" {
    source  = "ionosphere-io/managed-prefix-list/aws"

    # Change version to the current version of this module.
    version = "..."

    # The AWS region to deploy to. This is required.
    region = "us-west-2"

    # The following variables are optional.

    # The location of your Terraform state file. The module tags all resources with a "Terraform"
    # tag set to this value for easier identification that the resource is managed by a Terraform
    # stack. Defaults to "1".
    tf_state = "s3://bucket/key"

    # The amount of memory to allocate to the Lambda function in MiB. Defaults to 256.
    lambda_memory_size = 256

    # If set to a non-empty value, the module does not create a Lambda role and uses this one
    # instead. This is useful in environments where you do not have permissions to create IAM
    # roles. The default value is empty, which causes this module to create a new IAM role.
    lambda_role_arn = ""

    # If lambda_role_arn is set to an empty value, this is the name prefix used to create a new
    # IAM role for the Lambda function. If empty, the prefix "ManageAWSPrefixLists-${var.region}"
    # is used.
    lambda_role_prefix = ""

    # When creating a new IAM role, this is the principal access is granted to. This value is
    # correct for AWS commercial and US GovCloud regions; it may differ in isolated regions.
    lambda_principal = "lambda.amazonaws.com"

    # The amount of time, in seconds, to allow the Lambda function to run before it is forcibly
    # terminated. The default is 300 seconds (5 minutes).
    lambda_timeout = 300
}
```
