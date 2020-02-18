output "web_url" {
  value = "http://${module.elb_web.this_elb_dns_name}/"
}

output "db_addr" {
  value = "${module.rds.this_db_instance_address}"
}