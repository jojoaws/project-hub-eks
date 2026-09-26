Project Hub is a full-stack application deployed on Amazon EKS using Terraform, Helm, Docker, and GitHub Actions.

The project was built to demonstrate a production-oriented AWS/Kubernetes deployment with secure networking, managed PostgreSQL, automated CI/CD, secrets management, workload identity, autoscaling, and Kubernetes observability.

```mermaid
flowchart TB
    User[Users]

    User --> CF[CloudFront]

    CF --> S3[Private S3<br/>Frontend]
    CF --> ALB[Application Load Balancer]

    ALB --> Ingress[EKS Ingress]
    Ingress --> Backend[Backend Service]
    Backend --> Pods[FastAPI Pods]

    Pods --> RDS[(RDS PostgreSQL)]

    Pods --> Metrics[/metrics/]
    Metrics --> Prometheus[Prometheus]

    KSM[kube-state-metrics] --> Prometheus
    NodeExporter[Node Exporter] --> Prometheus

    Prometheus --> Grafana[Grafana]
    Prometheus --> Alertmanager[Alertmanager]

Tech Stack
AWS
* Amazon EKS
* Amazon VPC
* Application Load Balancer
* Amazon RDS PostgreSQL
* Amazon ECR
* Amazon S3
* Amazon CloudFront
* AWS Secrets Manager
* IAM
* EKS Pod Identity

Kubernetes
* Kubernetes 1.33
* Helm
* AWS Load Balancer Controller
* External Secrets Operator
* Horizontal Pod Autoscaler
* Metrics Server
* NetworkPolicy
* Health probes
* Resource requests and limits
* Pod anti-affinity
* Topology spread constraints

Observability
* Prometheus
* Grafana
* Alertmanager
* kube-state-metrics
* Prometheus Node Exporter
* Prometheus FastAPI Instrumentator

CI/CD & IaC
* Terraform
* GitHub Actions
* GitHub Actions OIDC
* Docker
* Amazon ECR

Application
* React / Vite
* FastAPI
* PostgreSQL
* SQLAlchemy
* Alembic

Infrastructure
Terraform manages the AWS infrastructure, including:
* VPC and subnets
* EKS cluster and managed node group
* RDS PostgreSQL
* ECR
* S3
* CloudFront
* IAM
* Security groups
* Secrets Manager
* EKS Pod Identity

Worker nodes run in private subnets while public traffic enters through CloudFront and the Application Load Balancer.

Application Flow
Frontend traffic is served from a private S3 bucket through CloudFront.

API requests use the /api/* CloudFront route:
CloudFront
    ↓
ALB
    ↓
EKS Ingress
    ↓
Backend Service
    ↓
FastAPI Pods
    ↓
RDS PostgreSQL

The backend runs as multiple replicas and is protected by Kubernetes health checks, resource limits, NetworkPolicy, and controlled ingress.

Secrets & AWS Access
Application secrets are stored in AWS Secrets Manager and synchronized into Kubernetes using External Secrets Operator.
The backend uses EKS Pod Identity for AWS permissions instead of static AWS credentials.
GitHub Actions authenticates to AWS using OIDC, avoiding long-lived AWS access keys.

CI/CD
GitHub Actions automates infrastructure and application workflows.
Git Push
   │
   ├── Terraform validation / plan
   ├── Backend build
   ├── Docker image build
   ├── ECR push
   └── Kubernetes deployment

Observability
Prometheus collects Kubernetes, node, and application metrics.
The FastAPI backend exposes /metrics using prometheus-fastapi-instrumentator.
Grafana visualizes Prometheus metrics, while Alertmanager provides alert management.

The monitoring stack consists of:
Backend
   │
   ├── /metrics
   │
   ▼
Prometheus
   ├── kube-state-metrics
   ├── Node Exporter
   │
   ├──► Grafana
   └──► Alertmanager

Repository Structure
project-hub-eks/
├── .github/
│   └── workflows/
├── backend/
├── frontend/
├── kubernetes/
│   ├── templates/
│   └── observability/
└── terraform/

Key Engineering Practices

* Infrastructure as Code with Terraform
* Kubernetes deployment with Helm
* Private EKS worker nodes
* Managed PostgreSQL
* Secure workload identity
* Secrets management
* GitHub OIDC authentication
* Kubernetes autoscaling
* Application health probes
* Network policies
* Resource management
* Multi-AZ EKS nodes
* Kubernetes-native observability

Status
The Project Hub platform is deployed and running on Amazon EKS with automated CI/CD, AWS-managed infrastructure, secure secrets and identity management, application scaling, and a Prometheus/Grafana/Alertmanager observability stack.
