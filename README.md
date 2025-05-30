# 🌐 GCP Infrastructure Deployment with Terraform


## 🚀 Project Overview

This project provisions a secure, isolated, and production-ready **Kubernetes environment ( GKE )** using **Google Cloud Platform** and **Terraform**. It enforces best practices in cloud infrastructure design, including least privilege access, network segregation, and private artifact registries for image security.


## 🛡️ Project Infrastructure Design & Security Overview :

* A custom **VPC** with two segregated subnets:

  * **Management Subnet** : Hosts a private VM and a NAT Gateway.
  * **Restricted Subnet** : Hosts a **Private GKE Cluster** with private nodes and private control plane ( has no internet access ).
* **Custom Service Account** for GKE node pools.
* Access restrictions ensuring :

  * The restricted subnet has **no internet access**.
  * **Artifact Registry (private)** is used to store and serve Docker images for GKE.
  * Public access is only allowed via an **HTTP Load Balancer**.
  * Authorized networks feature enabled.
  * Docker images are pulled **only** from **private Artifact Registry**.
  * Access to the GKE cluster is allowed **only from the management subnet**.
* Code for the GKE app deployment is pulled from an external repository and pushed to **Google Artifact Registry** (GAR).


## 📋 Prerequisites

* [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.3.0
* [gcloud CLI](https://cloud.google.com/sdk/docs/install) (authenticated)
* [kubectl](https://kubernetes.io/docs/tasks/tools/) >= 1.25
* Docker (for building images)
* Git


## 🧰 Tech Stack

* **Terraform** – Infrastructure as Code
* **Google Cloud Platform (GCP)** – Cloud provider
* **Google Kubernetes Engine (GKE)** – Kubernetes cluster
* **Artifact Registry (GAR)** – Secure image storage
* **NAT Gateway** – Outbound internet access for private resources
* **HTTP Load Balancer** – Public endpoint for services


## 🔧 Infrastructure Deployment

### 🔁 1. Clone the Repository

```bash
git clone https://github.com/NaghamMohamedMohamed/GKE-Secure-Deployment.git
cd GKE-Secure-Deployment
```
---

### 🔐 2. Authenticate with GCP

```bash
gcloud init
gcloud auth login
gcloud auth application-default login
gcloud config set project [YOUR_PROJECT_ID]
```
---

### ⚙️ 3. Initialize Terraform

```bash
terraform init
```
---

### 🧮 4. Plan and Apply Terraform Configuration

```bash
terraform plan
terraform apply
```

This will provision ( The previous two steps must be executed in Terraform dir ):

* VPC and subnets
* NAT gateway in the management subnet
* Private GKE cluster in the restricted subnet
* Private VM in the management subnet
* Artifact Registry

---

### 🐳 5. Build and Push Docker Image to GAR

Clone the app repository :

```bash
git clone https://github.com/ahmedzak7/GCP-2025.git
cd GCP-2025/DevOps-Challenge-Demo-Code-master
```

Build and push the Docker image:

```bash
gcloud auth configure-docker

docker build -t [REGION]-docker.pkg.dev/[PROJECT_ID]/[REPO_NAME]/[IMAGE_NAME]:latest .
docker push [REGION]-docker.pkg.dev/[PROJECT_ID]/[REPO_NAME]/[IMAGE_NAME]:latest
```

- Replace `[PROJECT_ID]`, `[REGION]`, `[REPO_NAME]` , and `[IMAGE_NAME]` with your specific values.

---

## 🔑 6. Connect to Private VM & Access GKE

### A. SSH into Private VM 

```bash
gcloud compute ssh [VM_NAME] --zone=[ZONE] --tunnel-through-iap

```
### B. Install Required Tools ( on the VM )

```bash
sudo apt-get update 
sudo apt-get install -y kubectl 
sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin
```
### C. Verify Access to the GKE Cluster

```bash
kubectl get nodes
kubectl get pods -A
```

### D. Copy your files to the private vm : 

```bash
gcloud compute scp ./python-app-deployment.yml [VM_NAME]:/home/[USER]/ --zone=[ZONE] --tunnel-through-iap
gcloud compute scp ./redis-deployment.yml [VM_NAME]:/home/[USER]/ --zone=[ZONE] --tunnel-through-iap
gcloud compute scp ./ingress.yml [VM_NAME]:/home/[USER]/ --zone=[ZONE] --tunnel-through-iap
```
---

## 🚀 7. Deploy to GKE ( From inside the VM )

```bash
gcloud container clusters get-credentials [CLUSTER_NAME] --region [REGION] 

kubectl apply -f k8s-Manifests/python-app-deployment.yml
kubectl apply -f k8s-Manifests/redis-deployment.yml
kubectl apply -f k8s-Manifests/ingress.yml

```

## 🔍 8. Validate Kubernetes Manifests Deployment

```bash
kubectl get nodes
kubectl get pods
kubectl get deployments
kubectl get svc
```

---

## 🌍 9. Access the Application

```bash
kubectl get ingress
```
- This will output an EXTERNAL IP , which is the HTTP Load Balancer IP that exposes your app publicly ( Access the app via http://<EXTERNAL_IP> )
- You can also use CLI Method : cutl http://<EXTERNAL_IP>
---

