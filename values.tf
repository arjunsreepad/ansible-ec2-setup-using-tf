variable "image_id" {
  type = string
}

variable "region" {
  type = string
}

variable "access_id" {
  type = string
}

variable "secret_key" {
  type = string
  }

variable "ansible-master-instance-type" {
  type = string
  default = "t2.micro"
}

variable "ansible-slave-instance-type" {
  type = string
  default = "t2.micro"
}

variable "awsKey" {
  type = string
}