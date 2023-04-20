# resource "aws_cloudwatch_dashboard" "jenkins_dashboard" {
#   dashboard_name = "JenkinsEC2Monitoring"

#   dashboard_body = jsonencode({
#     "widgets" : [
#       {
#         "type" : "metric",
#         "x" : 0,
#         "y" : 0,
#         "width" : 12,
#         "height" : 6,
#         "properties" : {
#           "metrics" : [
#             ["AWS/EC2", "CPUUtilization", "InstanceId", "${aws_instance.jenkins_instance.id}"]
#           ],
#           "period" : 300,
#           "stat" : "Average",
#           "region" : "us-east-1", # Change this to the region you want to use
#           "title" : "Jenkins EC2 Server CPU Utilization"
#         }
#       },
#       {
#         "type" : "metric",
#         "x" : 12,
#         "y" : 0,
#         "width" : 12,
#         "height" : 6,
#         "properties" : {
#           "metrics" : [
#             ["AWS/EC2", "StatusCheckFailed", "InstanceId", "${aws_instance.jenkins_instance.id}"]
#           ],
#           "period" : 300,
#           "stat" : "SampleCount",
#           "region" : "us-east-1", # Change this to the region you want to use
#           "title" : "Jenkins EC2 Server Status Check Failed"
#         }
#       }
#     ]
#   })
# }