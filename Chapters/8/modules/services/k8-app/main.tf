terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "-> 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

locals {
  pod_lbl = {
    app_name = var.name
  }
  status = kubernetes_service.app.status

}

resource "kubernetes_deployment" "app" {
  metadata {
    name = var.name
  }
  spec {
    replicas = var.replicas
    template {
      metadata {
        labels = local.pod_lbl
      }
      spec {
        container {
          name = var.name
          image = var.image

          port {
            container_port = var.container_port
          }

          dynamic "env" {
            for_each = var.env_variables
            content {
              name = env.key
              value = env.value
            }
          }
        }
      }
    }
    selector {
      match_labels = local.pod_lbl
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name = var.name
  }
  spec {
    type = "LoadBalancer"
    port {
      port = 80
      target_port = var.container_port
      protocol = "TCP"
    }
    selector = local.pod_lbl
  }
}

