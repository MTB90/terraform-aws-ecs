# Resources
resource "aws_lambda_function" "thumbnail_lambda" {
  filename      = var.lambda_source
  function_name = var.tags["Name"]
  role          = aws_iam_role.lambda_role.arn
  handler       = var.lambda_handler
  timeout       = 10

  source_code_hash = filebase64sha256(var.lambda_source)
  runtime          = "python3.7"

  environment {
    variables = var.lambda_variables
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = format("%s-iam-role", var.tags["Name"])
  tags               = merge(var.tags, map("Name", format("%s-iam-role", var.tags["Name"])))
  assume_role_policy = file("${path.module}/../lambda-assume-role.json")
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_policy" "lambda_policy" {
  name        = format("%s-iam-policy", var.tags["Name"])
  path        = "/"
  description = "Policy for the Lambda Role."
  policy = var.lambda_policy
}

resource "aws_lambda_permission" "lambda_allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.thumbnail_lambda.arn
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_arn
}

resource "aws_sns_topic_subscription" "lambda_sns_topic_subscriptio" {
  topic_arn = var.sns_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.thumbnail_lambda.arn
}