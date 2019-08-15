resource "kubernetes_deployment" "tiller" {
    metadata {
        name = "tiller-deploy"
        namespace = "${var.tiller_namespace}"

        labels = {
            app = "helm"
            name = "tiller"
        }
    }

    spec {
        replicas = "${var.tiller_replicas}"

        selector {
            match_labels = {
                app = "helm"
                name = "tiller"
            }
        }

        template {
            metadata {
                labels = {
                    app = "helm"
                    name = "tiller"
                }
            }

            spec {

                container {
                    name = "tiller"
                    image = "${var.tiller_image}:${var.tiller_version}"
                    image_pull_policy = "IfNotPresent"


                    port {
                        name = "tiller"
                        container_port = 44134
                    }

                    port {
                        name = "http"
                        container_port = 44135
                    }

                    env {
                        name = "TILLER_NAMESPACE"
                        value = "${var.tiller_namespace}"
                    }

                    env {
                        name = "TILLER_HISTORY"
                        value = "${var.tiller_history}"
                    }

                    liveness_probe {
                        http_get {
                            path = "/liveness"
                            port = 44135
                        }

                        initial_delay_seconds = 1
                        timeout_seconds = 1
                    }

                    readiness_probe {
                        http_get {
                            path = "/readiness"
                            port = 44135
                        }

                        initial_delay_seconds = 1
                        timeout_seconds = 1
                    }

                    # https://github.com/terraform-providers/terraform-provider-kubernetes/issues/38#issuecomment-318581203
                    volume_mount {
                        mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
                        name = "${kubernetes_service_account.tiller.default_secret_name}"
                        read_only = true
                     }
                }

                volume {
                    name = "${kubernetes_service_account.tiller.default_secret_name}"

                    secret {
                        secret_name = "${kubernetes_service_account.tiller.default_secret_name}"
                    }
                }

                host_network = "${var.tiller_net_host}"
                node_selector = "${var.tiller_node_selector}"
            }
        }
    }
}