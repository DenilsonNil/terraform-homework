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
  type        = string
}

variable "password" {
  description = "senha do usuário"
  type        = string
}

resource "null_resource" "upload-app" {
  connection {
    type     = "ssh"
    host     = data.azurerm_public_ip.public-ip-homework-data.ip_address
    user     = var.user
    password = var.password
  }

  provisioner "file" {
    source      = "app"
    destination = "/home/adminuser"
  }
  # The VM needs to be on
  depends_on = [
    azurerm_linux_virtual_machine.vm-homework
  ]
}