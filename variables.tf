variable "vpc_id" {
  type = string

}
variable "my_ip_with_cidr" {
  type        = string
  description = "provide your ip eg 58.186.113.176/32"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "server_name" {
  type    = string
  default = "Apache-server"

}
