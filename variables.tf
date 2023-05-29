variable "vpc_id" {
  type = string

}
variable "my_ip_with_cidr" {
  type        = string
  description = "provide your ip eg 1.1.1.1/32"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "server_name" {
  type    = string
  default = "Apache-server"

}
