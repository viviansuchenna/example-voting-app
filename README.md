# Example-Voting-App (Kubernetes & DevOps Capstone)

## Project Overview
The **Example-Voting-App** is a multi-service cloud-native application designed to demonstrate microservice containerization, Kubernetes orchestration, continuous integration/continuous deployment (CI/CD) pipelines, and vulnerability scanning. 

Users cast votes between two options via a web frontend, votes are queued and processed asynchronously, and the final results are updated and displayed in real-time on a separate results dashboard.

---

## Application Architecture & Microservices

The application consists of five primary microservices:

* **Voting Frontend (`vote`):** Web interface built in Python (Flask) allowing users to cast votes.
* **In-Memory Queue (`redis`):** High-speed Redis instance that holds votes prior to background processing.
* **Worker Service (`worker`):** Background service built in .NET Core / Java that consumes votes from Redis and persists them into the database.
* **Database (`db`):** PostgreSQL database with a persistent volume providing long-term vote storage.
* **Result Frontend (`result`):** Real-time web dashboard built in Node.js & Socket.io displaying live voting totals.

---

## Repository Structure

```text
example-voting-app/
├──terraform/           # Infrastructure as a code (AWS VPC, Security Groups,EKS/EC2)
├── vote/               # Python web app front-end for voting
├── result/             # Node.js web app front-end for viewing results
├── worker/             # Background worker service (.NET / Java)
├── k8s-specifications/ # Kubernetes deployment & service YAML manifests
├── Helm/               # Helm charts for release management
├── .github/workflows/  # GitHub Actions CI/CD pipeline definitions
└── README.md           # Project documentation
## Prerequisites
 Container Runtime: Docker Desktop / Containerd

 Orchestration: Local or remote Kubernetes Cluster (kubectl)

 Package Management: Helm v3+

 Version Control: Git
 
## Deployment OptionsOption
#### 1: Deploying via Kubernetes Manifests

1. Create the Namespace:
```bash
create namespace voting-app

2. Apply Manifest
```bash
kubectl apply -f k8s-specifications/ -n voting-app

3. Verify Deployment:
```bash
kubectl get pods -n voting-app -w

#### 2: Deploying via Helm Chart

1. Install Chart:
```bash
 helm install voting-app ./Helm/ -n voting-app

2. Check Release Status:
```bash 
helm list -n voting-app

#### 3 :Provision Infrastructure with Terraform

Navigate to the `terraform/` directory to initialize and provision your target infrastructure (e.g., AWS 3-tier VPC and Kubernetes cluster):

```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve


#### 4. Update **Access Ports** to reflect **3000**:
```markdown
## Accessing the Applications

Once deployed, access the respective frontends via `port-forward` or NodePort:

* **Vote App:** `http://localhost:3000` (or `kubectl port-forward svc/vote 3000:80 -n voting-app`)
* **Result App:** `http://localhost:3001` (or `kubectl port-forward svc/result 3001:80 -n voting-app`)

## CI/CD & Security Integration
​ Automated Builds:
 GitHub Actions workflows handle unit testing and multi-architecture Docker image building.

​ Vulnerability Scanning:
Container images are scanned for vulnerabilities using Trivy prior to registry release.

​Authentication:
 Repository updates and container image pushes utilize securely stored Personal Access Tokens (PAT).
​Accessing the Applications
​Once deployed, access the respective frontends via port-forward or NodePort:

​Vote App: http://localhost:3000 (or kubectl port-forward svc/vote 3000:80 -n voting-app)
​Result App: http://localhost:3001 (or kubectl port-forward svc/result 3001:80 -n voting-app)

​Author
​Vivian Uchenna – DevOps Engineer
