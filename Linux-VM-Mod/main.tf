
# creating the Resource group 

resource "azurerm_resource_group" "resource-group" {
  name     = var.rg
  location = var.location
}

resource "azurerm_virtual_network" "virtual-network" {
  name                = var.vnet-name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on = [ azurerm_resource_group.resource-group, azurerm_virtual_network.virtual-network ]

}


resource "azurerm_public_ip" "pip" {
  name                = var.pip
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  allocation_method   = "Static"

}


resource "azurerm_network_interface" "nic" {
  name                = var.nic
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name

  ip_configuration {
    name                          = var.ipcon
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm-name
  resource_group_name = azurerm_resource_group.resource-group.name
  location            = azurerm_resource_group.resource-group.location
  size                = "Standard_F2"
  admin_username      = var.username
  admin_password      = var.password
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}