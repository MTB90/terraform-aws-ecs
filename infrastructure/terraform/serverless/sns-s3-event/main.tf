# Resources
data "aws_s3_bucket" "bucket" {
  bucket = var.file_storage
}

resource "aws_sns_topic" "sns_s3_event_notification_topic" {
  name = var.tags["Name"]
  tags = var.tags

  policy = <<POLICY
  {
      "Version":"2012-10-17",
      "Statement":[{
          "Effect": "Allow",
          "Principal": {"Service":"s3.amazonaws.com"},
          "Action": "SNS:Publish",
          "Resource":  "arn:aws:sns:${var.aws_region}:*:${var.tags["Name"]}",
          "Condition":{
              "ArnLike":{"aws:SourceArn":"${data.aws_s3_bucket.bucket.arn}"}
          }
      }]
  }
  POLICY
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = data.aws_s3_bucket.bucket.id

  topic {
    topic_arn     = aws_sns_topic.sns_s3_event_notification_topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "photo/"
  }
}