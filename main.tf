provider "aws" {
  region     = var.region
}

resource "aws_security_group" "lb_sg" {
    name = "${var.lb_name}_sg"
    description = "ALB ${var.lb_name}s Security Group"
    vpc_id = var.vpc_id
    
    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = var.lb_sg_tags
}

resource "aws_security_group_rule" "lb_sg_in" {
    count = length(var.ingress_tcp_ports)
    
    protocol = "tcp"
    type = "ingress"
    from_port = var.ingress_tcp_ports[count.index]
    to_port = var.ingress_tcp_ports[count.index]
    cidr_blocks = var.lb_in_cidr_blocks
    security_group_id = aws_security_group.lb_sg.id
}

resource "aws_lb" "alb" {
    name = var.lb_name
    load_balancer_type = "application"
    subnets = var.subnet_ids
    security_groups = [ aws_security_group.lb_sg.id ]
}

resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = var.lb_listener_port
    protocol = var.lb_listener_protocol
    certificate_arn = var.lb_listener_cert_arn

    default_action {
      type = "forward"

      target_group_arn = aws_lb_target_group.lb_tg.arn
    }
}

resource "aws_lb_target_group" "lb_tg" {
    name = "${var.lb_name}-tg"
    port = var.lb_target_port
    protocol = var.lb_target_protocol
    vpc_id = var.vpc_id

    health_check {
        healthy_threshold = var.lb_target_healthcheck_healthy_threshold
        unhealthy_threshold = var.lb_target_healthcheck_unhealthy_threshold
        timeout = var.lb_target_healthcheck_timeout
        path = var.lb_target_healthcheck_path
        protocol = local.alb_target_protocol
        port = local.alb_target_port
        interval = var.lb_target_healthcheck_interval
        matcher = var.lb_target_healthcheck_matcher
    }
}

resource "aws_lb_target_group_attachment" "instance_as_target" {
  target_group_arn = aws_lb_target_group.lb_tg.arn
  target_id        = var.lb_target_instance_id
}