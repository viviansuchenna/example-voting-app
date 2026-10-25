terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "minikube"
}

# --------------------------------------------------
# VOTE DEPLOYMENT
# --------------------------------------------------
resource "kubernetes_deployment" "vote" {
  metadata {
    name = "vote"
    labels = {
      app = "vote"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "vote"
      }
    }

    template {
      metadata {
        labels = {
          app = "vote"
        }
      }

      spec {
        container {
          image = "dockersamples/examplevotingapp_vote:before"
          name = "vote"

          port {
            container_port = 80
            protocol = "TCP"
          }
        }
      }
    }
  }
}

# --------------------------------------------------
# VOTE SERVICE
# --------------------------------------------------
resource "kubernetes_service" "vote" {
  metadata {
    name = "vote"
    labels = {
      app = "vote"
    }
  }

  spec {
    type = "NodePort"
    selector = {
      app = "vote"
    }

    port {
      port = 80
      target_port = 80
      node_port = 30000
    }
  }
}
# --------------------------------------------------
# REDIS DEPLOYMENT
# --------------------------------------------------
resource "kubernetes_deployment" "redis" {
  metadata {
    name = "redis"
    labels = {
      app = "redis"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
        }
      }

      spec {
        container {
          image = "redis:alpine"
          name = "redis"

          port {
            container_port = 6379
            name = "redis"
          }
        }
      }
    }
  }
}

# --------------------------------------------------
# REDIS SERVICE
# --------------------------------------------------
resource "kubernetes_service" "redis" {
  metadata {
    name = "redis"
    labels = {
      app = "redis"
    }
  }

  spec {
    selector = {
      app = "redis"
    }

    port {
      port = 6379
      target_port = 6379
    }
  }
}

# --------------------------------------------------
# POSTGRES DEPLOYMENT
# --------------------------------------------------
resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"
    labels = {
      app = "postgres"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          image = "postgres:15-alpine"
          name = "postgres"

          env {
            name = "POSTGRES_PASSWORD"
            value = "postgres"
          }
          env {
            name = "POSTGRES_USER"
            value = "postgres"
          }

          port {
            container_port = 5432
            name = "postgres"
          }
        }
      }
    }
  }
}

# --------------------------------------------------
# POSTGRES SERVICE
# --------------------------------------------------
resource "kubernetes_service" "postgres" {
  metadata {
    name = "db"
    labels = {
      app = "postgres"
    }
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port = 5432
      target_port = 5432
    }
  }
}

# --------------------------------------------------
# WORKER DEPLOYMENT
# --------------------------------------------------
resource "kubernetes_deployment" "worker" {
  metadata {
    name = "worker"
    labels = {
      app = "worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "worker"
      }
    }

    template {
      metadata {
        labels = {
          app = "worker"
        }
      }

      spec {
        container {
          image = "dockersamples/examplevotingapp_worker"
          name = "worker"
        }
      }
    }
  }
}

# --------------------------------------------------
# RESULT DEPLOYMENT
# --------------------------------------------------
resource "kubernetes_deployment" "result" {
  metadata {
    name = "result"
    labels = {
      app = "result"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "result"
      }
    }

    template {
      metadata {
        labels = {
          app = "result"
        }
      }

      spec {
        container {
          image = "dockersamples/examplevotingapp_result"
          name = "result"

          port {
            container_port = 80
            name = "result"
          }
        }
      }
    }
  }
}

# --------------------------------------------------
# RESULT SERVICE
# --------------------------------------------------
resource "kubernetes_service" "result" {
  metadata {
    name = "result"
    labels = {
      app = "result"
    }
  }

  spec {
    type = "NodePort"
    selector = {
      app = "result"
    }

    port {
      port        = 80
      target_port = 80
      node_port = 31001
    }
  }
}
