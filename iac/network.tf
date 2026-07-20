resource "google_compute_network" "main" {
  name                    = "${var.app_name}-${var.environment}-vpc"
  auto_create_subnetworks = false

  depends_on = [
    google_project_service.required
  ]
}

resource "google_compute_subnetwork" "public" {
  name                     = "${var.app_name}-${var.environment}-public-subnet"
  region                   = var.region
  network                  = google_compute_network.main.id
  ip_cidr_range            = "10.10.1.0/24"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private" {
  name                     = "${var.app_name}-${var.environment}-private-subnet"
  region                   = var.region
  network                  = google_compute_network.main.id
  ip_cidr_range            = "10.10.2.0/24"
  private_ip_google_access = true
}

resource "google_compute_router" "main" {
  name    = "${var.app_name}-${var.environment}-router"
  region  = var.region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "main" {
  name                               = "${var.app_name}-${var.environment}-nat"
  region                             = var.region
  router                             = google_compute_router.main.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
