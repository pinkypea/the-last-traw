variable "region" {
        default = "ap-southeast-1"
}
variable "vpc_cidr_block"{
        default = "172.31.0.0/16"
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "the-last-straw-cluster"
}
variable "instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  default     = "t3.medium"  # Replace with your preferred instance type
}
variable "desired_capacity" {
  description = "Desired number of worker nodes"
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  default     = 2
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  default     = 2
}
variable "subnet_ids" {
        default = ["subnet-0d751b95d8f379114", "subnet-0dc43f2cb6d7399b2", "subnet-02b9d57ecb05f4cc5"]
}
variable "security_group_ids" {
        default = ["sg-0ba604bd99f764a3a"]
}
variable "db_name" {
  default = "postgres"
}

variable "db_username" {
  default = "postgres"
}

variable "db_password" {
  default = "postgres"
}