variable "tiller_namespace" {
    type = "string"
    default = "kube-system"
    description = "Kubernetes namespace destination for Tiller"
}

variable "tiller_service_account" {
    type = "string"
    default = "tiller"
    description = "Kubernetes serviceaccount used by Tiller"
}

variable "tiller_replicas" {
    default = 1
    description = "Number of Tiller replicas to run on Kubernetes cluster"
}

variable "tiller_image" {
    type = "string"
    default = "gcr.io/kubernetes-helm/tiller"
    description = "Docker image to use to install Tiller"
}

variable "tiller_version" {
    type = "string"
    default = "v2.14.1"
    description = "Tiller image version to install. Default v2.14.1"
}

variable "tiller_history" {
    default = 0
    description = "Maximum number of revisions per release. (Use 0 for no limit)"
}

variable "tiller_net_host" {
    type = bool
    default = true
    description = "Install tiller with net=host by default"
}

variable "tiller_node_selector" {
    type = "map"
    default = {}
    description = "Determine nodes that Tiller can land on"
}