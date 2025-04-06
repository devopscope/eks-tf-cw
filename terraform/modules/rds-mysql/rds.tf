resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "db_password" {
  name = var.db_password_secret_name
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    MYSQL_USER     = aws_db_instance.mysql.username
    MYSQL_PASSWORD = random_password.db_password.result
    MYSQL_HOST     = aws_db_instance.mysql.endpoint
    MYSQL_PORT     = aws_db_instance.mysql.port
    MYSQL_DATABASE = aws_db_instance.mysql.db_name
  })
}

resource "aws_db_instance" "mysql" {
  # identifier        = "mysql-instance"
  engine            = "mysql"
  engine_version    = var.engine_version
  instance_class    = var.rds_instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db_password.result

  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name = aws_db_subnet_group.mysql.name
}

resource "aws_security_group" "rds" {
  name        = "rds-security-group"
  description = "Security group for RDS MySQL instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
}

resource "aws_db_subnet_group" "mysql" {
  name       = "mysql-subnet-group"
  subnet_ids = var.private_subnet_ids
}
