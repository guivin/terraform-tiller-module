# Tiller Terraform Module [![Build Status](https://travis-ci.com/vingcen/terraform-tiller-module.svg?token=BMz7e5ocAJFLzxUW4pFx&branch=master)](https://travis-ci.com/vingcen/terraform-tiller-module)
> A terraform module to install Tiller for Helm on your Kubernetes cluster

# Description

Tiller is the in-cluster component of Helm. It interacts directly with the Kubernetes API server to install, upgrade, query, and remove Kubernetes resources. It also stores the objects that represent releases. (https://helm.sh/docs/glossary/).

This terraform module configures rbac for Tiller before installing it.

You can customized and automate Tiller installation : numbers of replicas you want, used tiller account name, namespace, used docker image and version etc..

# How to use it ?

In your terraform file define kubernetes provider and call the module :

```terraform

provider "kubernetes" {
    config_path = "${pathexpand("~/.kube/config")}
}

module "tiller" {
    source = "git@github.com:vingcen/terraform-tiller-module.git?ref=master"
}
```

You can override default values of variables by adding them in parameter of the module.


Make a terraform init :

```
$ terraform init
```

Make a terraform apply :

```
$ terraform apply
```

You can ensure that Tiller is running in your K8S cluster :

````
$ kubectl get all -n kube-system -l app=helm
NAME                                 READY   STATUS    RESTARTS   AGE
pod/tiller-deploy-65dd89df58-bxfwp   1/1     Running   0          3d22h

NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)     AGE
service/tiller-deploy   ClusterIP   10.107.87.206   <none>        44134/TCP   3d22h

NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/tiller-deploy   1/1     1            1           3d22h

NAME                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/tiller-deploy-65dd89df58   1         1         1       3d22h


$ helm version
Client: &version.Version{SemVer:"v2.14.1", GitCommit:"5270352a09c7e8b6e8c9593002a73535276507c0", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.14.1", GitCommit:"5270352a09c7e8b6e8c9593002a73535276507c0", GitTreeState:"clean"}
````

# Modules variables

| Name                      | Description                                   | Default                 |
| -------------             | -------------                                 | -------------           |
| `tiller_namespace`        | Kubernetes namespace where to install Tiller  | kube-system             |
| `tiller_replicas`         | Amount of replicas for Tiller                 | 1                       |
| `tiller_service_account`  | Kubernetes serviceaccount name for Tiller     | tiller                  |
| `tiller_image`            | Docker image to use for Tiller                | gcr.io/kubernetes-helm/tiller                      |
| `tiller_version`          | Tiller version to use                         | v2.14.1                 |
| `tiller_history`          | Maximum number of revisions per release. (Use 0 for no limit)                                          | 0                        |
| `tiller_net_host`         | Install tiller with net=host by default                                              | true            |
| `tiller_node_selector`    | Determine nodes that Tiller can land on                                              | {}                       |