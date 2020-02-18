region = "eu-west-2"
public_key = ""
name = "kpmg-3t"

# VPC
vpc_azs = [ "eu-west-2a", "eu-west-2b" ]
vpc_cidr = "10.10.0.0/16"
vpc_private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
vpc_public_subnets  = ["10.10.101.0/24", "10.10.201.0/24"]
vpc_database_subnets = ["10.10.102.0/24", "10.10.202.0/24"]
vpc_enable_nat_gateway = true
vpc_single_nat_gateway = false
vpc_one_nat_gateway_per_az = true

db_identifier = "kpmg-3t"
db_name = "soccer"
db_username = "kpmg"
db_password = "kpmg!kpmg"
#db_allocated_storage = 
#db_port = 
#db_backup_window = 
#db_backup_retention_period = 
#db_maintenance_window = 

#app_port = 
#web_port = 
#web_instance_type = 
#web_autoscale_min_size = 
#web_autoscale_max_size = 
#web_elb_health_check_interval = 
#web_elb_healthy_threshold = 
#web_elb_unhealthy_threshold = 
#web_elb_health_check_timeout = 
