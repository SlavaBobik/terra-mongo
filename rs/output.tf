output "Public ip" {
  value = "${digitalocean_droplet.replicaset.*.ipv4_address}"
}