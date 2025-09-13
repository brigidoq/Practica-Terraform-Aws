# Data source para obtener AMI más reciente
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Security Group
resource "aws_security_group" "main" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Security group para ${var.project_name}"
  vpc_id      = var.vpc_id

  # Reglas de ingreso
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Regla de egreso (todo el tráfico saliente)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-sg"
  })
}

# Key Pair (opcional)
resource "aws_key_pair" "main" {
  count = var.key_name != "" ? 1 : 0

  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = var.public_key

  tags = var.common_tags
}

# Launch Template
resource "aws_launch_template" "main" {
  name_prefix   = "${var.project_name}-${var.environment}-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name != "" ? aws_key_pair.main[0].key_name : null

  vpc_security_group_ids = [aws_security_group.main.id]

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    project_name = var.project_name
    environment  = var.environment
  }))

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${var.project_name}-${var.environment}"
    })
  }

  tags = var.common_tags
}

# Instancias EC2
resource "aws_instance" "main" {
  count = var.instance_count

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  subnet_id = element(var.subnet_ids, count.index)

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-${count.index + 1}"
  })
}

# Load Balancer (opcional)
resource "aws_lb" "main" {
  count = var.create_load_balancer ? 1 : 0

  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-alb"
  })
}

# Target Group
resource "aws_lb_target_group" "main" {
  count = var.create_load_balancer ? 1 : 0

  name     = "${var.project_name}-${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = var.common_tags
}

# Listener para Load Balancer
resource "aws_lb_listener" "main" {
  count = var.create_load_balancer ? 1 : 0

  load_balancer_arn = aws_lb.main[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }
}

# Attachment de instancias al Target Group
resource "aws_lb_target_group_attachment" "main" {
  count = var.create_load_balancer ? var.instance_count : 0

  target_group_arn = aws_lb_target_group.main[0].arn
  target_id        = aws_instance.main[count.index].id
  port             = 80
}