resource "aws_cloudwatch_metric_alarm" "jenkins_cpu_alarm" {
  alarm_name          = "jenkins-ec2-cpu-usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  alarm_description   = "This metric checks if the CPU usage of the Jenkins EC2 instance exceeds 80%"
  alarm_actions       = [aws_sns_topic.cpu_alarm.arn]
  dimensions = {
    InstanceId = aws_instance.jenkins_instance.id
  }
  statistic = "SampleCount"
  threshold = "80"
}

resource "aws_sns_topic" "cpu_alarm" {
  name = "jenkins-cpu-alarm"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.cpu_alarm.arn
  protocol  = "email"
  endpoint  = "admin@techstarterepublic.co" # Replace this with your email address
}