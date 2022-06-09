#VM Storage
resource "azurerm_storage_account" "vm-storage-homework" {
  name                     = "saaulainfra"
  resource_group_name      = azurerm_resource_group.rg-homework.name
  location                 = azurerm_resource_group.rg-homework.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

#Linux VM
resource "azurerm_linux_virtual_machine" "vm-homework" {
  name                = "vm"
  resource_group_name = azurerm_resource_group.rg-homework.name
  location            = azurerm_resource_group.rg-homework.location
  size                = "Standard_DS1_V2"

  network_interface_ids = [
    azurerm_network_interface.network-interface-homework.id,
  ]

  admin_username                  = var.user
  admin_password                  = var.password
  disable_password_authentication = false

  os_disk {
    name                 = "mydisc"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vm-storage-homework.primary_blob_endpoint
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}