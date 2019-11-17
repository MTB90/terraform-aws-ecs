{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:CreateCluster",
                "ecs:DeregisterContainerInstance",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:StartTelemetrySession",
                "ecs:UpdateContainerInstancesState",
                "ecs:Submit*",
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:CreateLogGroup",
                "logs:DescribeLogStreams"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:*:*:table/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:DescribeDocument",
                "ssm:GetDefaultPatchBaseline",
                "ssm:GetParameterHistory",
                "ssm:GetPatchBaselineForPatchGroup",
                "ssm:GetParameters",
                "ssm:GetOpsSummary",
                "ssm:GetParameter",
                "ssm:GetMaintenanceWindowTask",
                "ssm:ListTagsForResource",
                "ssm:DescribeDocumentParameters",
                "ssm:DescribeEffectivePatchesForPatchBaseline",
                "ssm:GetDocument",
                "ssm:GetServiceSetting",
                "ssm:DescribeDocumentPermission",
                "ssm:GetMaintenanceWindow",
                "ssm:GetParametersByPath",
                "ssm:GetPatchBaseline"
            ],
            "Resource": "arn:aws:ssm:eu-west-1:*:parameter/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": ["arn:aws:s3:::${storage}", "arn:aws:s3:::${storage}/*"]
        }
    ]
}