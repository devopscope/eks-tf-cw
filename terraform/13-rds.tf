# resource "random_password" "db_password" {
#   length  = 16
#   special = false
# }

# resource "aws_secretsmanager_secret" "db_password" {
#   name = "mysql-db-password"
# }

# resource "aws_secretsmanager_secret_version" "db_password" {
#   secret_id = aws_secretsmanager_secret.db_password.id
#   secret_string = jsonencode({
#     username = "admin"
#     password = random_password.db_password.result
#     host     = aws_db_instance.mysql.endpoint
#     port     = 3306
#     dbname   = aws_db_instance.mysql.db_name
#   })
# }

# resource "aws_db_instance" "mysql" {
#   identifier           = "mysql-instance"
#   engine              = "mysql"
#   engine_version      = "8.0"
#   instance_class      = "db.t3.micro"
#   allocated_storage   = 10
#   storage_type       = "gp2"
  
#   db_name             = "testdb"
#   username           = "admin"
#   password           = random_password.db_password.result
  
#   skip_final_snapshot = true
  
#   vpc_security_group_ids = [aws_security_group.rds.id]
#   db_subnet_group_name   = aws_db_subnet_group.mysql.name
# }

# resource "aws_security_group" "rds" {
#   name        = "rds-security-group"
#   description = "Security group for RDS MySQL instance"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = [aws_vpc.main.cidr_block]
#   }
# }

# resource "aws_db_subnet_group" "mysql" {
#   name       = "mysql-subnet-group"
#   subnet_ids = [aws_subnet.private_zone1.id, aws_subnet.private_zone2.id]
# }

# # Outputs
# output "rds_endpoint" {
#   value = aws_db_instance.mysql.endpoint
# }

# output "secret_arn" {
#   value = aws_secretsmanager_secret.db_password.arn
# } 