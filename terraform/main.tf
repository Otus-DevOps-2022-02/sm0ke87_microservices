resource "yandex_vpc_network" "default" {
  name = "default"
}

resource "yandex_vpc_subnet" "a" {
  network_id = yandex_vpc_network.default.id

  name = "a"
  zone = "ru-central1-a"

  v4_cidr_blocks = ["10.16.0.0/16"]
}

module "kubernetes" {
  source = "posha90/managed-kubernetes/yandex"

  name = "default"

  folder_id        = var.folder_id
  network_id       = yandex_vpc_network.default.id
  master_locations = [
    {
      subnet_id = yandex_vpc_subnet.a.id
      zone      = yandex_vpc_subnet.a.zone
    }
  ]

  service_account_name      = "k8s-manager"
  node_service_account_name = "k8s-node-manager"

  master_version  = var.kubernetes_version
  release_channel = var.kubernetes_release_channel

  node_groups = {
    "default" = {
      cores         = 4
      core_fraction = 100
      memory        = 4
      fixed_scale   = {
        size = 3
      }
      boot_disk_type = "network-ssd"
      boot_disk_size = 40
    }
  }
}
