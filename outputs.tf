output "vm_ip_address" {
  description = "Public IP address of the VM"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = google_compute_instance.vm.name
}

output "vm_image" {
  description = "Image used to create the VM"
  value       = data.google_compute_image.ubuntu.name
}

output "website_url" {
  description = "Full URL of the deployed web service"
  value       = "http://${google_compute_instance.vm.network_interface[0].access_config[0].nat_ip}:${var.web_port}"
}
