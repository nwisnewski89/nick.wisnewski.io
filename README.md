# Steps
1. Buy Domain + SSL Cert
2. Build resume site with Gatsby.js
3. Build Docker image with Nginx server
4. Build internal microk8s cluster on Rasberry-Pis running Ubuntu Server 22.04.3 LTS
5. Terraform for GKE cluster, Cloud DNS, and Load Balancer
6. Create namespace, Load Balancer Ingress, and Deployment via K8s specs on both clusters
7. Push image to GHCR with Github Actions 
8. Deploy GHCR image to internal cluster (figure out automation for this ... webhook on raspi?)
9. Create release tag post internal test
10. Github Actions release workfor to push to Google container registry and deploy updated app

# Work notes
## GCP
1. Set up GCP account
2. [Install gcloud](https://cloud.google.com/sdk/docs/install)
3. `gcloud auth login`
4. Set default login `gcloud auth application-default login --project ${PROJECT_ID}`
5. Run terraform locally to deploy cluster
6. Setup billing alerts

## Internal Cluster
Pre Steps
1. Pi-Imager Write - Ubuntu 22.04.03 LTS server with customization
2. SSH to host secure server w/ ufw
3. Run ansible playbook to configure microK8s cluster