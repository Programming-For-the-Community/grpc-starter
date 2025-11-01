variable "region" {
  description = "AWS Region to build infrastructure in"
  type        = string
  default     = "us-east-2"
  nullable    = false
}

variable "owner" {
  description = "Owner of the project"
  type        = string
  nullable    = false
  default     = "Charlie Hahm"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  nullable    = false
  default     = "1234567890"
}

variable "project" {
  description = "Name of the project"
  type        = string
  nullable    = false
  default     = "AWS gRPC Starter"
}

variable "tf_project_name" {
  description = "Name of the project"
  type        = string
  nullable    = false
  default     = "aws-grpc-starter"
}

variable "all_traffic" {
  description = "CIDR block for all traffic"
  type        = string
  default     = "0.0.0.0/0"
  nullable    = false
}

variable "vpc_cidr" {
  description = "CIDR block for professorchaos0802_vpc"
  type        = string
  nullable    = false
  default     = "194.75.0.0/16"
}

variable "vpc_id" {
  description = "ID for professorchaos0802_vpc"
  type        = string
  nullable    = false
  default     = "vpc_professorchaos0802"
}

variable "private1_subnet_cidr" {
  description = "CIDR block for nodejs-starter subnet A"
  type        = string
  nullable    = false
  default     = "10.0.2.0/28"
}

variable "private2_subnet_cidr" {
  description = "CIDR block for nodejs-starter subnet B"
  type        = string
  nullable    = false
  default     = "10.0.2.16/28"
}

variable "private3_subnet_cidr" {
  description = "CIDR block for nodejs-starter subnet C"
  type        = string
  nullable    = false
  default     = "10.0.2.32/28"
}

variable "public1_subnet_cidr" {
  description = "CIDR block for nodejs-starter public subnet 1"
  type        = string
  nullable    = false
  default     = "10.0.2.48/28"
}

variable "public2_subnet_cidr" {
  description = "CIDR block for nodejs-starter public subnet 2"
  type        = string
  nullable    = false
  default     = "10.0.2.64/28"
}

variable "public3_subnet_cidr" {
  description = "CIDR block for nodejs-starter public subnet 2"
  type        = string
  nullable    = false
  default     = "10.0.2.80/28"
}
