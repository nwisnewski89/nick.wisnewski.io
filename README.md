# Site Build

* Utilized the Gatsby.js [Starter Blog Template](https://www.gatsbyjs.com/starters/gatsbyjs/gatsby-starter-blog) and [Material UI](https://mui.com/material-ui/getting-started/) to create a simple resume site.
* Built the static site into a docker image with an Nginx Server.
* Created a free tier GCP account to host the application in GKE. 
* Utilized [KubeIP](https://github.com/doitintl/kubeIP) to avoid paying for an Ingress Load Balancer in order to keep costs down.
* Modelled the ingress Nginx reverse proxy server from the blog [Affordable Kubernetes for Personal Projects](https://redmaple.tech/blogs/affordable-kubernetes-for-personal-projects/).
* Bought the `wisnewski.io` domain and an SSL certifcate for `nick.wisnewski.io`, leveraging GCP Cloud DNS.

# K8s Cluster Creation

1. Run the `site-resources` Terraform module to create GCP resources.
2. Connect the the cluster with gcloud and create the namespace `wisnewski-io` and the TLS sercret in the namespace.
3. Run the `k8s-resources` Terraform module to create all the cluster resources.

# CI

* Utilize a [path filter](https://github.com/dorny/paths-filter) to determine build steps
* Build docker images and push to GCP Artifact registry if change was detected.
* Apply Terraform for GCP resources terraform resources were updated, need to apply if k8s resources update to refresh to the token for the kubernetes provider.
* Apply Terraform for K8s resources if updated.
* If either docker image was built authenticate to GCP, install `kubectl` and authenticate to cluster with `gcloud`.
* Preform rolling restart of the deployment corresponding to the docker image that was built.


