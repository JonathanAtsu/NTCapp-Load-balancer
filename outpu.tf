// output the DNS name of the load balancer
output "alb_dns_name" {
  value = aws_alb.ntc-alb.dns_name
}   
output "alb_arn" {
  value = aws_alb.ntc-alb.arn
}
output "alb_zone_id" {
  value = aws_alb.ntc-alb.zone_id
}