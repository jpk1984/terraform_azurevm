resource "azurerm_resource_group" "rg_name"{
    name    = var.rg_name
    location = "var.location"
    
    tags = {
        environment = var.tags
    }
}

resource "azurerm_virtual_network" "vnet_address_space" {
    name            = "var.location"
    address_space   = var.vnet_address_space
    location        = azurerm_resource_group.rg_name.location
    resource_group_name = azurerm_resource_group.rg_name.name

    tags = {
        environment = var.location
    }
}

resource "azurerm_subnet" "vnet_subnet_id"{
    name                    = var.location
    resource_group_name     = azurerm_resource_group.rg_name.location
    virtual_network_name    = azurerm_virtual_network.rg_name.subnet_id
    address_prefixes        = var.address_prefixes
}

# public ips
resource "azurerm_public_ip" "public_ip" {
    name                = var.public_ip
    location            = var.location
    resource_group_name = azurerm_resource_group.rg_name.name

    tags = {

        environment  = var.location  
          }

}

# Network Security Group and rule
resource "azurerm_netwrok_security_group" "vent_security_group" {
    name                = var.vent_security_group
    location            = var.location
    resource_group_name = azurerm_resource_group.rg_name

    Security_rule{
        name                        = "SSH"
        priority                    = 1001
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destiantion_port_range      = "22"
        source_address_prefix       = "*"
        destination_address_prefix = "*"
    }
    tags = {
        environment = var.location

    }

}

#Network interface 
resource "azurerm_network_interface" "network_interface_id" {
    name                     = var.network_interface_id
    location                 = var.location
    resource_group_name      = azurerm_resource_group.rg_name.name

    ip_configuration {
        name                            = var.vm_nic
        subnet_id                       = azurerm_subnet.subnet_id
        private_ip_address_allocation   = "Dynamic"
        public_ip_address_id            = azurerm_public_ip_address_id.Inbound
   }

   tags = {
       environment = var.location
   }
}
# The Security group to the Network interface
resource "azurerm_netwrok_interface_security_group_association" "rg_name"{
    network_interface_id                = var.network_interface_id
    azurerm_netwrok_security_group_id   = var.vent_security_group 
    }
# Create virtual machine
resource "azurerm_linux_virtual_machine" "virtual_machine" {
    name                    = var.virtual_machine
    location                = var.location
    resource_group_name     = azurerm_resource_group.rg_name.name
    network_interface_ids   = [azure_netwrok_interface.network_interface_id.id]
    size                    = var.virtual_machine

    os_disk {
        name            = "OsDisk"
        caching         = "ReadWrite"
    }

    source_image_reference {
        publisher   = "Canonical"
        offer       = "UbunterServer"
        sku         = "18.04-LTS"
        version     = "latest"
    }

    computer_name      = var.virtual_machine
    admin_username     = var.admin_username
    password           = var.password

    tags = {
        environment = var.location
        }
}




