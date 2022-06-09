terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

# Null resource to install web server
data "azurerm_public_ip" "public-ip-homework-data" {
  name                = azurerm_public_ip.public-ip-homework.name
  resource_group_name = azurerm_resource_group.rg-homework.name
}

resource "null_resource" "install-webserver" {
  connection {
    type     = "ssh"
    host     = data.azurerm_public_ip.public-ip-homework-data.ip_address
    user     = var.user
    password = var.password
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y apache2"
    ]
  }
  # The VM needs to be on
  depends_on = [
    azurerm_linux_virtual_machine.vm-homework
  ]
}

variable "user" {
  description = "usuario da máquina"
  type = string
}

variable "password" {
  description = "senha do usuário"
  type = string
}

resource "null_resource" "upload-app" {
  connection {
    type     = "ssh"
    host     = data.azurerm_public_ip.public-ip-homework-data.ip_address
    user     = var.user
    password = var.password
  }

  provisioner "file" {
    source =  "app"
    destination = "/home/adminuser"
  }
  # The VM needs to be on
  depends_on = [
    azurerm_linux_virtual_machine.vm-homework
  ]
}