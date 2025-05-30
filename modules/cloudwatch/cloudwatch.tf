resource "aws_sns_topic" "cloudwatch_alerts" {
  name = "cloudwatch-alerts-topic"
}

resource "aws_sns_topic_subscription" "team_email_subscription" {
  topic_arn = aws_sns_topic.cloudwatch_alerts.arn
  protocol  = "email"
  endpoint  = "kknr8367@gmail.com"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/hcl-hackathon"
  retention_in_days = 30
}

resource "aws_cloudwatch_metric_alarm" "ecs_task_failure_alarm" {
  alarm_name          = "ecs-task-failure-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "Triggers when ECS Task CPU utilization exceeds 90%"
  # actions_enabled     = true
  alarm_actions       = [aws_sns_topic.cloudwatch_alerts.arn]

  dimensions = {
    ClusterName = "hcl-hackathon-devops-kamal-ECSFargate"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_alarm" {
  alarm_name          = "ecs-high-memory-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 85
  alarm_description   = "Triggers when ECS Task memory exceeds 85%"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.cloudwatch_alerts.arn]

  dimensions = {
    ClusterName = "hcl-hackathon-devops-kamal-ECSFargate"
  }
}

#Uptodate the ECS service to use the log group