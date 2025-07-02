# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"  # or your desired default region
}


variable "vpc_cidr" {
  description = "CIDR block for the SageMaker VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the SageMaker subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone for the subnet"
  type        = string
  default     = "us-east-1a"
}

variable "execution_role_name" {
  description = "Name of the SageMaker execution IAM role"
  type        = string
  default     = "sagemaker-execution-role"
}

variable "sg_name" {
  description = "Name of the security group for SageMaker"
  type        = string
  default     = "sagemaker-sg"
}

variable "notebook_name" {
  description = "Name of the SageMaker notebook instance"
  type        = string
  default     = "my-sagemaker-notebook"
}

variable "notebook_instance_type" {
  description = "Instance type for the SageMaker notebook"
  type        = string
  default     = "ml.t2.medium"
}

variable "lifecycle_config_name" {
  description = "Lifecycle configuration name for the notebook"
  type        = string
  default     = ""
}

variable "training_job_name" {
  description = "Name of the SageMaker training job"
  type        = string
  default     = "my-training-job"
}

variable "training_image" {
  description = "Docker image used for training"
  type        = string
  default     = "382416733822.dkr.ecr.us-east-1.amazonaws.com/linear-learner:latest"
}

variable "input_data_s3_uri" {
  description = "S3 URI for the input training data"
  type        = string
  default     = "s3://my-bucket/training-data/"
}

variable "output_data_s3_uri" {
  description = "S3 URI where training output will be saved"
  type        = string
  default     = "s3://my-bucket/training-output/"
}

variable "training_instance_type" {
  description = "Instance type for the training job"
  type        = string
  default     = "ml.m4.xlarge"
}

variable "model_name" {
  description = "Name of the SageMaker model"
  type        = string
  default     = "my-sagemaker-model"
}

variable "endpoint_config_name" {
  description = "Name of the endpoint configuration"
  type        = string
  default     = "my-endpoint-config"
}

variable "endpoint_instance_type" {
  description = "Instance type for the deployed model endpoint"
  type        = string
  default     = "ml.t2.medium"
}

variable "endpoint_name" {
  description = "Name of the SageMaker endpoint"
  type        = string
  default     = "my-sagemaker-endpoint"
}

variable "model_artifact_s3_uri" {
  description = "S3 URI for the trained model artifact"
  default     = "s3://my-bucket/output/model.tar.gz" # Update as needed
}
