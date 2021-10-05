resource "azurerm_resource_group" "texzteam"{
    name    = var.rg_name
    location = "us-west-2"
    
    tags = {
        environment = "texzteam demo"
    }
}

resource "azurerm_virtual_network" "texzteamvnet" {
    name            = "myVnet"
    address_space   = ["10.0.0.0/16"]
    location        = "us-west-2"
    resource_group_name = azurerm_resource_group.texzteam.name

    tags = {
        environment = "texzteamdemo"
    }
}

resource "azurerm_subnet" "texzteamsubnet"{
    name        = "mySubnet"
    resource_group_name = azurerm_resource_group.texzteam.name
    virtual_network_name = azurerm_virtual_network.texzteamvnet.name
    address_prefixes     = ["10.0.10/24"]
}

# public ips
resource "azurerm_public_ip" "texzteampublicip" {
    name                = "mypublicIP"
    location            = "us-west-2"
    resource_group_name = azurerm_resource_group.texzteam.name

    tags = {

        environment  = "texzteam demo"    }

}

# Network Security Group and rule
resource "azurerm_netwrok_security_group" "texteamnsg" {
    name                = "texzteamnsg"
    location            = "us-west-2"
    resource_group_name = azurerm_resource_group.texzteam.name

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
        environment = "texzteam demo"

    }

}

#Network interface 
resource "azurerm_network_interface" "texteamnic" {
    name        = "myNIC"
    location    = "us-west-2"
    resource_group_name     = azurerm_resource_group.texzteam.name

    ip_configuration {
        name                    = "myNicConfiguration"
        subnet_id               = azurerm_subnet.texzteamsubnet.subnet_id
        private_ip_address_allocation   = "Dynamic"
        public_ip_address_id            = azurerm_public_ip.texzteampublicip.Inbound
   }

   tags = {
       environment = "texzteam demo"
   }
}
# The Security group to the Network interface
resource "azurerm_netwrok_interface_security_group_association" "texzteam"{
    network_interface_id        = azurerm_network_interface.texteamnic.subnet_id
    azurerm_netwrok_security_group_id   = azurerm_netwrok_interface_security_group.texteamnsg.subnet_id 
    }
# Create virtual machine
resource "azurerm_linux_virtual_machine" "texzteamvm" {
    name                    = "texzVM"
    location                = "us-west-2"
    resource_group_name     = azurerm_resource_group.texzteam.name
    network_interface_ids   = [azure_netwrok_interface.texteamnic.id]
    size                    = "Standard_DS1_v2"

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

    computer_name      = "texzVM"
    admin_username     = ""
    password           = ""

    tags = {
        environment = "texzteam demo"
        }
}




