resource "aws_sfn_state_machine" "transaction_pipeline" {
  name     = "${var.project_name}-pipeline"
  role_arn = aws_iam_role.step_function_role.arn

  definition = jsonencode({
    StartAt = "ValidateTransaction",
    States = {
      ValidateTransaction = {
        Type     = "Task",
        Resource = module.lambda_validate.lambda_function_arn,
        Next     = "AssessRisk"
      },
      AssessRisk = {
        Type     = "Task",
        Resource = module.lambda_risk_assess.lambda_function_arn,
        Next     = "RiskChoice"
      },
      RiskChoice = {
        Type = "Choice",
        Choices = [
          {
            Variable     = "$.risk_level",
            StringEquals = "high",
            Next         = "RouteToReview"
          }
        ],
        Default = "RouteToApproved"
      },
      RouteToReview = {
        Type     = "Task",
        Resource = module.lambda_route.lambda_function_arn,
        Next     = "FlagAsHighRisk"
      },
      RouteToApproved = {
        Type     = "Task",
        Resource = module.lambda_route.lambda_function_arn,
        Next     = "ProcessSuccess"
      },
      FlagAsHighRisk = {
        Type  = "Fail",
        Error = "HighRiskDetected",
        Cause = "Transaction flagged for manual review."
      },
      ProcessSuccess = {
        Type = "Succeed"
      }
    }
  })
}
