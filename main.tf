terraform{
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "~> 3.0"
        }
    }
}

provider "docker" {}

resource "docker_image" "nextapp" {
    name = "mridhophs/my-next-app:latest"
    keep_locally = false
}

resource "docker_container" "nextapp" {
    name = "nextapp"
    image = docker_image.nextapp.image_id
    ports {
        internal = 3000
        external = 8080
    }
}