# =================================
# Required variables
# =================================

variable "vpc"              {}
variable "vpc_name"         {}
variable "env"              {}
variable "subnet_id"        {}
variable "public_ip"        {}
variable "instance_type"    {}
variable "name"             {}
variable "instance_count"   {}
variable "security_groups"  {type = "list"}
variable "playbook"         {default = ""}
variable "destroy"          {default = ""}
