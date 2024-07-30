# INPUTS
variable "instance_type" {
  default = "t2.micro"
}
variable "instance_name" {
  default = "HelloWorld"
}
variable "instance_ami" {
  default = "ami-01b799c439fd5516a"
}
variable "subnet_name" {
  default = "tf-example"
}
variable "vpc_name" {
  default = "tf-example"
}