//TARGET GROUP ATTACHMENT
resource "aws_alb_target_group" "alb-TG1" {
  name        = "ntc-tg1"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.my-vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 10
    timeout             = 6
    healthy_threshold   = 5
    unhealthy_threshold = 2
    port                = "traffic-port"
    enabled             = true

  }
  depends_on = [aws_vpc.my-vpc]
}
//attach instances to target group      
resource "aws_alb_target_group_attachment" "target1" {
  target_group_arn = aws_alb_target_group.alb-TG1.arn
  target_id        = aws_instance.server1.id
  port             = 80
}
resource "aws_alb_target_group_attachment" "target2" {
  target_group_arn = aws_alb_target_group.alb-TG1.arn
  target_id        = aws_instance.server2.id
  port             = 80
}
// create ALB
resource "aws_alb" "ntc-alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
  enable_deletion_protection = false
  idle_timeout       = 400
  depends_on         = [aws_vpc.my-vpc]
  tags = {
    Name = "my-alb"
    Env  = "dev"
  }
} 
// create listener
resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.ntc-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb-TG1.arn
  }
}  