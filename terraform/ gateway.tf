
resource "aws_api_gateway_rest_api" "api_assignment_engine" {
  name        = "${var.app_name}-API"
}


resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.api_assignment_engine.id
   parent_id   = aws_api_gateway_rest_api.api_assignment_engine.root_resource_id
   path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxyMethod" {
   rest_api_id   = aws_api_gateway_rest_api.api_assignment_engine.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.api_assignment_engine.id
   resource_id = aws_api_gateway_method.proxyMethod.resource_id
   http_method = aws_api_gateway_method.proxyMethod.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.assignment_engine_lambda.invoke_arn
   depends_on = [
    aws_lambda_function.assignment_engine_lambda
   ]
}

resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.api_assignment_engine.id
   resource_id   = aws_api_gateway_rest_api.api_assignment_engine.root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.api_assignment_engine.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.assignment_engine_lambda.invoke_arn
}

resource "aws_api_gateway_stage" "lambda_stage" {
  deployment_id = aws_api_gateway_deployment.apideploy.id
  rest_api_id   = aws_api_gateway_rest_api.api_assignment_engine.id
  stage_name    = var.app_env
}


resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.api_assignment_engine.id
}

resource "aws_api_gateway_base_path_mapping" "gateway_mapping" {
  api_id      = aws_api_gateway_rest_api.api_assignment_engine.id
  stage_name  = aws_api_gateway_stage.lambda_stage.stage_name
  domain_name = aws_api_gateway_domain_name.lambda_domain.domain_name
}