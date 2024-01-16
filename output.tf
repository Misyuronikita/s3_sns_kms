output "s3_bucket_name" {
  value = aws_s3_bucket.bucket.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.topic.arn
}

output "subscription_endpoint" {
  value = aws_sns_topic_subscription.subscription.endpoint
}
