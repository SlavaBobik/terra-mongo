variable "token" {}
variable "ssh" {}

provider "digitalocean" {
  token = var.token
}

resource "digitalocean_droplet" "replicaset" {
  count              = 3
  name               = "rs${count.index}"
  image              = "ubuntu-18-04-x64"
  region             = "fra1"
  size               = "s-2vcpu-2gb"
  private_networking = true
  ssh_keys           = [var.ssh]

  provisioner "file" {
    connection {
      host = self.ipv4_address
    }

    destination = "/etc/mongod.conf"
    content  = "${templatefile("${path.module}/templates/config.tmpl", { addr = self.ipv4_address_private})}"
  }

  provisioner "remote-exec" {
    connection {
      host = self.ipv4_address
    }
    
    inline = [
      "wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -",
      "echo 'deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list",
      "apt-get update",
      "apt-get install -y -o Dpkg::Options::=--force-confdef mongodb-org",
      "service mongod start",
    ]
  }
}
