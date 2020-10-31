output "lambda_function_arn" {
    description = "The ARN of the Lambda function deployed to manage prefix lists."
    value = aws_lambda_function.manage_aws_prefix_lists.arn
}

output "lambda_code_base_url" {
    description = "The S3 URL of the Lambda code deployed to the Lambda function (without the version id)."
    value = "s3://${aws_lambda_function.manage_aws_prefix_lists.s3_bucket}/${aws_lambda_function.manage_aws_prefix_lists.s3_key}"
}

output "lambda_code_url" {
    description = "The S3 URL of the Lambda code deployed to the Lambda function."
    value = "s3://${aws_lambda_function.manage_aws_prefix_lists.s3_bucket}/${aws_lambda_function.manage_aws_prefix_lists.s3_key}?versionId=${aws_lambda_function.manage_aws_prefix_lists.s3_object_version}"
}

output "lambda_code_object_version" {
    description = "The S3 object version of the Lambda code deployed to the Lambda function."
    value = aws_lambda_function.manage_aws_prefix_lists.s3_object_version
}
