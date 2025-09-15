terraform{
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "~> 3.0"
        }
    }
}

provider "docker" {}

resource "docker_image" "app_latest" {
    name = "mridhophs/my-next-app:latest"
    keep_locally = false
}

resource "docker_image" "app_dev"{
    name = "mridhophs/my-next-app:dev"
    keep_locally = false
}

resource "docker_container" "app_latest" {
    name = "nextjs-latest"
    image = docker_image.app_latest.image_id
    ports {
        internal = 3000
        external = 3001
  }
}

resource "docker_container" "app_dev" {
    name = "nextjs-dev"
    image = docker_image.app_dev.image_id
    ports {
        internal = 3000
        external = 3002
    }
}

resource "docker_image" "nginx"{
    name = "nginx:alpine"
}

resource "docker_container" "nginx"{
    name = "nginx-proxy"
    image = docker_image.nginx.image_id
    ports {
        internal = 80
        external = 80
    }
    volumes {
        host_path      = "${path.module}/nginx.conf"
        container_path = "/etc/nginx/nginx.conf"
        read_only      = true
    }
}