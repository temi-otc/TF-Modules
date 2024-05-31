# Creating resource group
/*
resource "azurerm_resource_group" "rg" {
  name     = var.rg
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  address_space       = var.vnet-add
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "sub1" {
  name                 = var.sub1
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = var.vnet
  address_prefixes     = var.sub-add1
  depends_on           = [azurerm_virtual_network.vnet]
}

resource "azurerm_subnet" "sub2" {
  name                 = var.sub2
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = var.vnet
  address_prefixes     = var.sub-add2
  depends_on           = [azurerm_virtual_network.vnet]
}

# Creating public Ip 

resource "azurerm_public_ip" "public-ip" {
  count               = 2
  name                = "${var.vm-pip}-${format("%02d", count.index + 1)}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
}


#Create NSG

resource "azurerm_network_security_group" "nsg-vm" {
  name                = var.nsg
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#associate NSG to SUbnet

resource "azurerm_subnet_network_security_group_association" "nsgass01" {
  subnet_id                 = azurerm_subnet.sub1.id
  network_security_group_id = azurerm_network_security_group.nsg-vm.id
  depends_on                = [azurerm_subnet.sub1]
}

resource "azurerm_subnet_network_security_group_association" "nsgass02" {
  subnet_id                 = azurerm_subnet.sub2.id
  network_security_group_id = azurerm_network_security_group.nsg-vm.id
  depends_on                = [azurerm_subnet.sub2]
}

## Create NIC

resource "azurerm_network_interface" "vm-nic" {
  count               = 2
  name                = "${var.nic}-${format("%02d", count.index + 1)}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name


  ip_configuration {
    name                          = var.ipconfig
    subnet_id                     = element([azurerm_subnet.sub1.id, azurerm_subnet.sub2.id], count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.public-ip.*.id, count.index + 1)

  }

}

# Create VM

resource "azurerm_windows_virtual_machine" "vm-name" {
  count                 = 2
  name                  = "${var.vm-name}-${format("%02d", count.index + 1)}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_E2s_v3"
  admin_username        = var.username
  admin_password        = random_string.string.result
  network_interface_ids = [element(azurerm_network_interface.vm-nic.*.id, count.index)]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-pro"
    version   = "latest"
  }
}

resource "random_string" "string" {
  length    = 16
  upper     = true
  min_upper = 1
  lower     = true
  min_lower = 1
  special = true
  numeric   = true
}
*/