variable "region" {
    description = "AWS Region Name"
    type = string
}

variable "lb_name" {
    description = "Load Balancer Name"
    type = string
}

variable "subnet_ids" {
    description = "Subnet IDs"
    type = list(string)
}

variable "vpc_id" {
    description = "ID of current VPC"
    type = string
}

variable "lb_sg_tags" {
    description = "Load Balancer's Security Group's tags"
    type = map(string)
    default = null
}

variable "ingress_tcp_ports" {
    description = "allowed tcp ports in security group"
    type = list(number)
}

variable "lb_in_cidr_blocks" {
    description = "allowed cidr blocks"
    type = list(string)
    default = [ "0.0.0.0/0" ] 
}

variable "lb_listener_port" {
    description = "Port for ALB Listener"
    type = string
}

variable "lb_listener_protocol" {
    description = "Protocol for ALB Listener"
    type = string
}

variable "lb_listener_cert_arn" {
    description = "Certificate arn for ALB Listener"
    type = string
}