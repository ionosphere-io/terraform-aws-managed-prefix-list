provider "aws" {
    region = var.region
}

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_s3_bucket_object" "manage_aws_prefix_lists_code" {
    bucket = "ionosphere-public-${var.region}"
    key = "manage-aws-prefix-lists.zip"
}

resource "aws_iam_role" "lambda" {
    count = (var.lambda_role_arn == "" ? 1 : 0)
    name_prefix = local.lambda_role_prefix
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
                "Service": "${var.lambda_principal}"
            },
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": ["${var.region}"]
                }
            }
        }
    ]
}
EOF

     description = "Lambda role for ManageAWSPrefixLists in ${var.region}"
}

resource "aws_iam_role_policy" "lambda" {
    count = (var.lambda_role_arn == "" ? 1 : 0)
    role = aws_iam_role.lambda[count.index].id

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateManagedPrefixList",
                "ec2:DeleteManagedPrefixList",
                "ec2:DescribeManagedPrefixLists",
                "ec2:GetManagedPrefixListAssociations",
                "ec2:GetManagedPrefixListEntries",
                "ec2:ModifyManagedPrefixList",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "sns:Publish",
                "ssm:GetParameters",
                "ssm:PutParameter",
                "sts:GetCallerIdentity"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": ["${var.region}"]
                }
            }
        },
        {
            "Action": [
                "ssm:AddTagsToResource",
                "ssm:ListTagsForResource"
            ],
            "Effect": "Allow",
            "Resource": "arn:${data.aws_partition.current.partition}:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:resource/*"
        }
    ]
}
EOF
}

resource "aws_lambda_function" "manage_aws_prefix_lists" {
    function_name = "ManageAWSPrefixLists"
    handler = "manage-aws-prefix-lists"
    s3_bucket = data.aws_s3_bucket_object.manage_aws_prefix_lists_code.bucket
    s3_key = data.aws_s3_bucket_object.manage_aws_prefix_lists_code.key
    s3_object_version = data.aws_s3_bucket_object.manage_aws_prefix_lists_code.version_id
    memory_size = var.lambda_memory_size
    role = (var.lambda_role_arn == "" ? aws_iam_role.lambda[0].arn : var.lambda_role_arn)
    runtime = "go1.x"
    timeout = var.lambda_timeout
    tags = {
        Terraform = var.tf_state
    }
}

resource "aws_lambda_permission" "manage_aws_prefix_lists_cloudwatch" {
    function_name = aws_lambda_function.manage_aws_prefix_lists.function_name
    action = "lambda:InvokeFunction"
    statement_id = "AllowPeriodicEvents"
    principal = "events.amazonaws.com"
    source_arn = "arn:${data.aws_partition.current.partition}:events:${var.region}:${data.aws_caller_identity.current.account_id}:rule/*"
}
