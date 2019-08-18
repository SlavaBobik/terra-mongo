output "public_ips" {
  value = digitalocean_droplet.replicaset.*.ipv4_address
}

output "rs_config" {
  value = "${templatefile("${path.module}/templates/rs_conf.tmpl", { private_ips = digitalocean_droplet.replicaset.*.ipv4_address_private })}"
}
