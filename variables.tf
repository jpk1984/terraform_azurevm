variable "rg_name" {
    type        = string
    description = "the resource group name"
    default     = "my-lab-rg"
}
variable "location"{
    type            = string
    description     = "Azure location server"
    default         = "westus2"
}

variable "tags"{
    type         = string
    description  = "Azure tags"
    default      = "my-lab"
}
variable "vnet_address_space" {
    type        = list
    description = "the virtualnetwork"
    default    = ["10.0.0.0/16"]

}
variable "vnet_subnet_id" {
    type        = list
    description = "the virtualsubnet"
    default     = ["10.0.1.0/24"]
}
variable    "public_ip" {
    type        = list
    description = "the public_ip"
    
}
variable "vent_security_group"{
    type            = list
    description     = "the security group" 
    default         = [null]
}
variable "network_interface_id" {
    type        = list
    description = "the network interface"
    default     = [null]
}
        
variable "os"{
    type = object({
        publisher   = string
        offer       = string
        sku         = string
        version     = string
    })
}

variable "admin_username" {
    type        = string
    description = "Administrator usernmae for server"
    
}
variable "password"{
    type        = bool
    description = "the password"   
    default     = false
}

variable "vm_size" {
    type        = string
    description = "size of vm"
    default     = "Standard_DS1_v2"
}
variable "vm_nic" {
    type            = list
    description     = "the nic"
    
}
variable "virtual_machine" {
    type        = string
    description = "the virtual machine"
    default     = "Standard_DS1_v2"
}
variable "computer_name" {
    type            = string
    description     = "the server"
    default         =  "TECH"
}