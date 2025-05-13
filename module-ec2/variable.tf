variable "ami" {
    type = string
}
variable "instance_type" {
    type = string
    default = "t2.micro"
}
variable "instance_count" {
  type = number
}
variable "pub_subnet_id" {
    type = string
}
variable "security_grp" {
    type = list(string)
}
variable "root_volume_size" {
  type        = number
  default     = 10
}

variable "root_volume_type" {
  type        = string
  default = "gp3"
}
variable "extra_volume" {
  type = list(object({
    size        = number
    type        = string
    device_name = string
  }))
}

variable "tags" {
    type = map(string)
    default = {
    }
}
variable "aws_ec2" {
  type = map(object({
    ami           = string
    instance_type = string
  }))
}
  variable "dev_env" {
  type = string
  default = "dev"
}