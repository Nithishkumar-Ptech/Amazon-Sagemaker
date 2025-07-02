
# VPC for SageMaker
resource "aws_vpc" "sagemaker_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "sagemaker-vpc"
  }
}

# Subnet for SageMaker
resource "aws_subnet" "sagemaker_subnet" {
  vpc_id                  = aws_vpc.sagemaker_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
  tags = {
    Name = "sagemaker-subnet"
  }
}



# Security Group for SageMaker
resource "aws_security_group" "sagemaker_sg" {
  name        = var.sg_name
  description = "Allow SageMaker traffic"
  vpc_id      = aws_vpc.sagemaker_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SageMaker Notebook
resource "aws_sagemaker_notebook_instance" "notebook" {
  name                  = var.notebook_name
  instance_type         = var.notebook_instance_type
  role_arn              = aws_iam_role.sagemaker_execution_role.arn
  security_groups       = [aws_security_group.sagemaker_sg.id]
  subnet_id             = aws_subnet.sagemaker_subnet.id
  lifecycle_config_name = var.lifecycle_config_name
}

# SageMaker Training Job
resource "null_resource" "trigger_training_job" {
  provisioner "local-exec" {
    command = <<EOT
      aws sagemaker create-training-job \
        --training-job-name "${var.training_job_name}" \
        --region "${var.aws_region}" \
        --role-arn "${aws_iam_role.sagemaker_execution_role.arn}" \
        --algorithm-specification TrainingImage=${var.training_image},TrainingInputMode=File \
        --input-data-config '[{"ChannelName":"training","DataSource":{"S3DataSource":{"S3DataType":"S3Prefix","S3Uri":"${var.input_data_s3_uri}","S3DataDistributionType":"FullyReplicated"}},"ContentType":"text/csv"}]' \
        --output-data-config S3OutputPath=${var.output_data_s3_uri} \
        --resource-config InstanceType=${var.training_instance_type},InstanceCount=1,VolumeSizeInGB=50 \
        --stopping-condition MaxRuntimeInSeconds=3600
    EOT
  }

  depends_on = [aws_iam_role.sagemaker_execution_role]
}





# SageMaker Model
resource "aws_sagemaker_model" "model" {
  name               = var.model_name
  execution_role_arn = aws_iam_role.sagemaker_execution_role.arn
  primary_container {
    image          =var.training_image
    model_data_url = var.model_artifact_s3_uri
  }
}

# Endpoint configuration
resource "aws_sagemaker_endpoint_configuration" "endpoint_config" {
  name = var.endpoint_config_name
  production_variants {
    variant_name           = "AllTraffic"
    model_name             = aws_sagemaker_model.model.name
    initial_instance_count = 1
    instance_type          = var.endpoint_instance_type
  }
}

# SageMaker Endpoint
resource "aws_sagemaker_endpoint" "endpoint" {
  name                 = var.endpoint_name
  endpoint_config_name = aws_sagemaker_endpoint_configuration.endpoint_config.name
}
