# IAM role for SageMaker
resource "aws_iam_role" "sagemaker_execution_role" {
  name = var.execution_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sagemaker_policy_attach" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-training-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
  inline_policy {
   name = "sagemaker-training-policy"
   policy = jsonencode({
     Version = "2012-10-17"
     Statement = [
       {
        Action = [
           "s3:GetObject",
           "s3:PutObject",
           "s3:ListBucket",
           "s3:AbortMultipartUpload",
           "s3:DeleteObject"
         ]
         Effect   = "Allow"
         Resource = "arn:aws:s3:::your-s3-bucket/*"
       },
        {
          Action = [
           "logs:CreateLogStream",
           "logs:PutLogEvents",
           "logs:CreateLogGroup"
          ]
          Effect   = "Allow"
          Resource = "arn:aws:logs:*:*:*"
        },
        {
          Action = [
            "ecr:BatchCheckLayerAvailability",
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
          ]
          Effect = "Allow"
          Resource = "*"
        }
     ]
   })
 }
}