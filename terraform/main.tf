provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "platform" {
  backend = "s3"
  config = {
    key     = var.remote_state_key
    bucket  = var.remote_state_bucket
    region  = var.region
  }
}

resource "aws_lambda_function" "assignment_engine_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
#  filename      = var.filename
  timeout       = 300
  image_uri     = "${data.terraform_remote_state.platform.outputs.ecr_assignment_engine_url}:${var.service_tag}"
  function_name = var.app_name
  role          = aws_iam_role.iam_for_lambda.arn
#  handler       = "index.test"
#  create_package = false
  package_type  = "Image"
#  architectures = ["arm64"]
#  runtime = " python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.assignment_engine_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api_assignment_engine.execution_arn}/*/*"
  depends_on = [
    aws_api_gateway_rest_api.api_assignment_engine
  ]
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.app_name}"
  retention_in_days = 14
}