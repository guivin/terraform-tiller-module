resource "kubernetes_service_account" "tiller" {
    metadata {
        name = "tiller"
        namespace = "${var.tiller_namespace}"
    }
}

resource "kubernetes_cluster_role_binding" "tiller" {
    metadata {
        name = "${var.tiller_service_account}"
    }

    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind      = "ClusterRole"
        name      = "cluster-admin"
    }

    subject {
        kind      = "ServiceAccount"
        name      = "${kubernetes_service_account.tiller.metadata.0.name}"
        namespace = "${var.tiller_namespace}"

        # See https://github.com/terraform-providers/terraform-provider-kubernetes/issues/204
        api_group = ""
    }
}
