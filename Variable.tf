
variable "vpc-cidr-block" {
  type    = string
  default = "10.0.0.0/16"

}


variable "public" {
  type    = string
  default = "wordpress-public-subnet"
}
variable "private" {
  type    = string
  default = "wordpress-private-subnet"
}

variable "ami" {

  type    = string
  default = "ami-0323d48d3a525fd18"

}