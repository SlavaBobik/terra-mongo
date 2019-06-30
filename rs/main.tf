variable "token" {}
variable "ssh" {}

provider "digitalocean" {
  token = "${var.token}"
}

resource "digitalocean_droplet" "replicaset" {
  count = 3
  name = "rs${count.index}"
  image = "ubuntu-18-04-x64"
  region = "fra1"
  size = "s-2vcpu-2gb"
  private_networking = true
  ssh_keys = ["${var.ssh}"]

  provisioner "remote-exec" {
    inline = [
      "apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4",
      "echo \"deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list",
      "apt-get update",
      "apt-get install -y mongodb-org",
      "service mongod start"
    ]
  }

  provisioner "local-exec" {
    command = "echo ${self.ipv4_address_private} >> private_ips.txt"
  }
}
