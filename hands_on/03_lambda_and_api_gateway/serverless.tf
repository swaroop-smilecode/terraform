# ----------------------------------------------------------------------------
# Lambda Function creation involves many steps. Let's code them block by block.

# Cipping .py file.
# Lambda function requires say_hi_function.py file in zip format.
data "archive_file" "lambda_zip_file" {
  type        = "zip"
  source_file = "lambda/say_hi_function.py"
  output_path = "lambda/say_hi_function.zip"
}

# IAM role.
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = file("lambda-policy.json")
  # Once you open the "lambda-policy.json" file, you will see keys named "Principal" & "Action".
  # This policy is telling, what "Action" can be performed by "Principal".
  # That's it.
  # Think about policy in this way.
}

# Attaching IAM role to lambda function.
resource "aws_iam_role_policy_attachment" "lambda_exec_role_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function.
resource "aws_lambda_function" "yt_lambda_function" {
  filename      = "lambda/say_hi_function.zip"
  function_name = "say_hi"
  role          = aws_iam_role.lambda_role.arn
  handler       = "say_hi_function.handler"
  runtime       = "python3.13"
  timeout       = 30
  # When ever we deploy lambda, new hash will be created for zip file that is deployed.
  # This hash code will be used by lambda internally to identify the function in O(n) run time.
  source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256

  environment {
    variables = {
      country = "swiss"
    }
  }
}
# ----------------------------------------------------------------------------
# Create API Gateway
resource "aws_api_gateway_rest_api" "yt_api" {
  name        = "yt-api"
  description = "API for Demo"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "yt_api_resource" {
  parent_id   = aws_api_gateway_rest_api.yt_api.root_resource_id
  path_part   = "demo-path"
  rest_api_id = aws_api_gateway_rest_api.yt_api.id
}

resource "aws_api_gateway_method" "yt_method" {
  resource_id   = aws_api_gateway_resource.yt_api_resource.id
  rest_api_id   = aws_api_gateway_rest_api.yt_api.id
  http_method   = "POST"
  authorization = "NONE" # In next hands_on, will do authorization by cognito.
}
# ----------------------------------------------------------------------------
# Integrate lambda with AIP gateway.
# Comment this block for custom response.
resource "aws_api_gateway_integration" "lambda_integration" {
  http_method             = aws_api_gateway_method.yt_method.http_method
  resource_id             = aws_api_gateway_resource.yt_api_resource.id
  rest_api_id             = aws_api_gateway_rest_api.yt_api.id
  integration_http_method = "POST"
  # API gateway sends response to lambda & lambda forwards it to user.
  # Here you have 2 options.
  # 1. Customize the response & then send to user("AWS_PROXY")
  # 2. Don't customize the response & just forward to user("AWS")
  type = "AWS_PROXY"
  uri  = aws_lambda_function.yt_lambda_function.invoke_arn
}
# ----------------------------------------------------------------------------
# Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.yt_api.id
  stage_name  = "dev"

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.yt_api_resource.id,
      aws_api_gateway_method.yt_method.id,
      aws_api_gateway_integration.lambda_integration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.yt_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.yt_api.execution_arn}/*/*/*"
}

output "invoke_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}
