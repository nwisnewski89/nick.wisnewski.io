#!/usr/bin/env bash
GCP_SERVICE_ACCOUNT="wisnewski-kubeip-prod@${PROJECT_ID}.iam.gserviceaccount.com"
K8S_SERVICE_ACCOUNT=kubeip-service-account
NAMESPACE=kube-system

gcloud container node-pools update wisnewski-ingress-pool-prod \
    --cluster=wisnewski-k8s-cluster-prod \
    --zone=${ZONE} \
    --workload-metadata=GKE_METADATA

kubctl apply -f gke-resources/kubeip/service-account.yml

gcloud iam service-accounts add-iam-policy-binding ${GCP_SERVICE_ACCOUNT} \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:${PROJECT_ID}.svc.id.goog[${NAMESPACE}/${K8S_SERVICE_ACCOUNT}]"

kubectl annotate serviceaccount ${K8S_SERVICE_ACCOUNT} \
    --namespace ${NAMESPACE} \
    iam.gke.io/gcp-service-account=${GCP_SERVICE_ACCOUNT}
