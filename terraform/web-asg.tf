resource "aws_security_group" "web" {
  name = format("%s-web", var.name)

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = var.web_port
    to_port     = var.web_port
    protocol    = "tcp"
    security_groups = ["${aws_security_group.elb_web.id}"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Group = var.name
  }

}

#TODO REMOVE
resource "aws_key_pair" "web-key" {
  key_name = "web-key"
  public_key = var.public_key

}

resource "aws_launch_configuration" "web" {
  image_id        = data.aws_ami.amazon_linux.id
  instance_type   = var.web_instance_type
  security_groups = [aws_security_group.web.id]
  #TODO REMOVE
  key_name = "web-key"
  name_prefix = "${var.name}-web-vm"

  user_data = <<-EOF
              #!/bin/bash
              export HOME=/root/
              # install git/nginx
              yum install -y git gettext nginx
              echo "NETWORKING=yes" >/etc/sysconfig/network
              echo >> /root/.bashrc

              # install node
              curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.2/install.sh | bash
              . /root/.nvm/nvm.sh
              nvm install 10.19.0
              npm install -g pm2

              # setup sample app
              git clone https://github.com/tekicat/kpmg.git /tmp/kpmg
              mkdir -p /var/www/ && mv /tmp/kpmg/app /var/www/
              cd /var/www/app && npm install
              export DB_HOST="${module.rds.this_db_instance_address}" DB_PORT="${var.db_port}" DB_USER="${var.db_username}" DB_PASS="${var.db_password}" DB_NAME="${var.db_name}" APP_PORT="${var.app_port}"
              pm2 start /var/www/app/app.js

              # configure and start nginx
              export APP_PORT="${var.app_port}" WEB_PORT="${var.web_port}"
              envsubst '$${APP_PORT} $${WEB_PORT}' < nginx.conf.template > /etc/nginx/nginx.conf
              service nginx start
              EOF

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "web" {
  launch_configuration = aws_launch_configuration.web.id

  vpc_zone_identifier = flatten(["${module.vpc.public_subnets}"])

  load_balancers    = ["${module.elb_web.this_elb_name}"]
  health_check_type = "EC2"

  min_size = var.web_autoscale_min_size
  max_size = var.web_autoscale_max_size

  tag {
    key = "Group" 
    value = var.name
    propagate_at_launch = true
  }

}

variable "web_port" {
  description = "The port on which the web servers listen for connections"
  default = 80
}

variable "app_port" {
  description = "The port on which the nodejs app listen for connections"
  default = 3000
}

variable "web_instance_type" {
  description = "The EC2 instance type for the web servers"
  default = "t2.micro"
}

variable "web_autoscale_min_size" {
  description = "The fewest amount of EC2 instances to start"
  default = 2
}

variable "web_autoscale_max_size" {
  description = "The largest amount of EC2 instances to start"
  default = 3
}

