mock_provider "aws" {}

variables {
  name = "cga-1560-policy-test"
}

run "history_disabled_by_default" {
  command = plan
  assert {
    condition     = aws_cognito_user_pool.user_pool[0].password_policy[0].password_history_size == null
    error_message = "Existing consumers must retain the default disabled history policy."
  }
}

run "previous_password_rejected_by_policy" {
  command = plan
  variables {
    password_history_size = 1
  }
  assert {
    condition     = aws_cognito_user_pool.user_pool[0].password_policy[0].password_history_size == 1
    error_message = "The user pool must receive the requested password history size."
  }
}

run "out_of_range_history_rejected" {
  command = plan
  variables {
    password_history_size = 25
  }
  expect_failures = [var.password_history_size]
}
