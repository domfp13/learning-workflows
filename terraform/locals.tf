/*
Locals
	locals are a way to define a named expression 
	that can be used multiple times within a module without 
	needing to repeat the expression. Once a local value
	is defined, it cannot be overridden or changed. 
	(similar to varialbles). 
*/

locals {
  vpc_cidr = "10.0.0.0/16"

  tags = {
    Name      = var.project_name
    Blueprint = var.project_name
    Owner     = "Enrique Plata"
  }
}
