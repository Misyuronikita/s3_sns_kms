resource "random_string" "random" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_s3_bucket" "bucket" {
  bucket        = "misyuro-bucket-${random_string.random.result}"
  force_destroy = true
}

resource "aws_sns_topic" "topic" {
  name = var.topic_name
  # kms_master_key_id = aws_kms_alias.topic_key_alias.name // attach the KMS key 
  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Resource": "arn:aws:sns:${var.region}:${var.account_id}:${var.topic_name}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceAccount": "${var.account_id}"
        }
      }
    }
  ]
}
  POLICY
}

resource "aws_s3_bucket_notification" "notification" {
  bucket = aws_s3_bucket.bucket.id
  topic {
    topic_arn = aws_sns_topic.topic.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.endpoint
}
