terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_compute_instance" "gitlab" {
  name        = "gitlab-ci"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 6

  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 50

    }
  }

  network_interface {
    # Указан id подсети default-ru-central1-a
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    user-data = "${file("./metadata")}"
  }

  provisioner "local-exec" {
    command = "sleep 30;ANSIBLE_CONFIG=../gitlab-ansible/ansible.cfg ansible-playbook -u ${var.username} -e address='${self.network_interface.0.nat_ip_address}' -i '${yandex_compute_instance.gitlab.network_interface.0.nat_ip_address},' ../gitlab-ansible/playbook.yml"
  }
}
