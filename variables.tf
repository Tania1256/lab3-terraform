variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-central2"
}

variable "zone_a" {
  description = "Zone A"
  type        = string
  default     = "europe-central2-a"
}

variable "zone_b" {
  description = "Zone B"
  type        = string
  default     = "europe-central2-b"
}

variable "credentials_file" {
  description = "Path to GCP service account key JSON"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "subnet_a_cidr" {
  description = "Subnet A CIDR"
  type        = string
}

variable "subnet_b_cidr" {
  description = "Subnet B CIDR"
  type        = string
}

variable "web_port" {
  description = "Web server port"
  type        = number
}

variable "vm_name" {
  description = "Virtual machine name"
  type        = string
}

variable "network_name" {
  description = "VPC network name"
  type        = string
}

variable "subnet_a_name" {
  description = "Subnet A name"
  type        = string
}

variable "subnet_b_name" {
  description = "Subnet B name"
  type        = string
}

variable "server_name" {
  description = "Apache ServerName"
  type        = string
}

variable "doc_root" {
  description = "Apache DocumentRoot"
  type        = string
}

variable "student_surname" {
  description = "Student surname"
  type        = string
}

variable "student_name" {
  description = "Student name"
  type        = string
}

variable "variant_num" {
  description = "Variant number"
  type        = string
}
