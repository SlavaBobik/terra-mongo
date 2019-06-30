output "Public ip" {
  value = "${digitalocean_droplet.replicaset.*.ipv4_address}"
}

output "Private ip" {
  value = "${digitalocean_droplet.replicaset.*.ipv4_address_private}"
}