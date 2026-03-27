# -----------------------------------------
# Locals — глобальні теги для всіх ресурсів
# -----------------------------------------
locals {
  common_labels = {
    project = "lab3"
    variant = var.variant_num
    student = var.student_surname
    env     = "dev"
    owner   = "${var.student_surname}-${var.student_name}"
    managed = "terraform"
  }
}

# VPC Network
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

# Subnetworks
resource "google_compute_subnetwork" "subnet_a" {
  name          = var.subnet_a_name
  ip_cidr_range = var.subnet_a_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

resource "google_compute_subnetwork" "subnet_b" {
  name          = var.subnet_b_name
  ip_cidr_range = var.subnet_b_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

# Cloud Router + NAT
resource "google_compute_router" "router" {
  name    = "router-lab3-${var.variant_num}"
  region  = var.region
  network = google_compute_network.vpc.id
  project = var.project_id
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-lab3-${var.variant_num}"
  router                             = google_compute_router.router.name
  region                             = var.region
  project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# Firewall Rules
resource "google_compute_firewall" "allow_ssh" {
  name    = "fw-allow-ssh-${var.variant_num}"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["lab3-vm-${var.variant_num}"]
}

resource "google_compute_firewall" "allow_web" {
  name    = "fw-allow-web-${var.variant_num}"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = [tostring(var.web_port)]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["lab3-vm-${var.variant_num}"]
}

# Пошук образу Ubuntu
data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2404-lts-amd64"
  project = "ubuntu-os-cloud"
}

# VM Instance
resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = "e2-micro"
  zone         = var.zone_b
  project      = var.project_id

  tags   = ["lab3-vm-${var.variant_num}"]
  labels = local.common_labels

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_a.id
    access_config {
      # Наявність цього блоку створює External IP
    }
  }

  metadata = {
    ssh-keys       = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    startup-script = templatefile("${path.module}/bootstrap.sh", {
      web_port    = var.web_port
      server_name = var.server_name
      doc_root    = var.doc_root
    })
  }

  depends_on = [google_compute_router_nat.nat]
}