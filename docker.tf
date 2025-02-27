# Folosim Docker pentru a crea un environment bazat pe 3-tier architecture - frontend, backend si database 
provider "docker" {
  host = "unix:///var/run/docker.sock"  # comunicarea cu Docker in LINUX
}

# app_network este numele retelei Docker ce permite comunicarea între containere
resource "docker_network" "app_network" {
  name = "app_network"
}

# containerul pentru conexiunea cu React
resource "docker_container" "react_for_frontend" {
   name  = "react_for_frontend"
   image = "node:latest"
  
  # Conectarea containerului la rețeaua Docker
  networks_advanced {
    name = docker_network.app_network.name
  }

ports {
    internal = 3000
    external = 3000
  }
  
  # La pornirea containerului se instalează și se pornește React
  command = ["sh", "-c", "npm install && npm start"]
}

# containerul pentru conexiunea cu Node.js
resource "docker_container" "node_for_backend" {
  name  = "node_for_backend"
  image = "node:latest"
  

  networks_advanced {
    name = docker_network.app_network.name
  }

ports {
    internal = 8080
    external = 8080
  }

# La pornirea containerului se instalează și se pornește Node.js
  command = ["sh", "-c", "npm install && node server.js"]
}

# Containerul pentru MongoDB
resource "docker_container" "mongo_db" {
  name  = "mongo_db"
  image = "mongo:latest"
  
  networks_advanced {
    name = docker_network.app_network.name
  }

ports {
    internal = 27017
    external = 27017
  }
