# Umami Analytics on AWS EKS

A production-grade Kubernetes deployment of Umami Analytics on AWS EKS, demonstrating cloud-native best practices, GitOps workflows, and infrastructure automation.

**Application**: [https://umami.mohamed-uptime.com](https://umami.mohamed-uptime.com)

---

## About the Application

Umami is a simple, fast, privacy-focused alternative to Google Analytics. It provides website analytics while respecting user privacy - no cookies, no tracking across sites, and full compliance with GDPR, CCPA, and PECR.

### Why Umami?

- **Privacy-First**: No personal data collection, fully anonymized analytics
- **Lightweight**: Minimal performance impact on websites
- **Open Source**: Self-hosted with full control over your data
- **Real-Time**: Live visitor tracking and event monitoring
- **Simple Interface**: Clean dashboard with essential metrics

### Key Metrics Tracked

- Page views and unique visitors
- Traffic sources and referrers
- Geographic visitor distribution
- Device and browser statistics
- Custom event tracking
- Real-time visitor monitoring

[Umami Application Screenshot] <img width="940" height="481" alt="image" src="https://github.com/user-attachments/assets/d5d65237-cff0-42ef-92d2-7028d2b36e03" /><img width="940" height="465" alt="image" src="https://github.com/user-attachments/assets/d2e6a214-e271-4ed0-b45f-206b4868c510" />

)

---

## Architecture

<img width="940" height="727" alt="image" src="https://github.com/user-attachments/assets/2225da4c-206f-4fc0-a70b-ec919efaf4ea" />



### Infrastructure Overview

**Network Layer**: VPC with public/private subnets across two availability zones (us-east-1a, us-east-1b), Internet Gateway, NAT Gateway, and Network Load Balancer for high availability.

**Compute Layer**: EKS cluster running Kubernetes 1.28 with two t3.medium worker nodes in private subnets for security.

**Data Layer**: RDS PostgreSQL 15 Multi-AZ deployment with automated backups and encryption.

**Application Layer**: NGINX Ingress Controller for routing, Umami Analytics application, and supporting platform services.

**Monitoring Layer**: Prometheus for metrics collection and Grafana for visualization.

---

## Technology Stack

- **Cloud**: AWS (EKS, RDS, VPC, Route 53, NLB)
- **Infrastructure as Code**: Terraform
- **Container Orchestration**: Kubernetes 1.28
- **GitOps**: ArgoCD
- **CI/CD**: GitHub Actions
- **Ingress**: NGINX Ingress Controller
- **SSL/TLS**: cert-manager with Let's Encrypt
- **DNS Automation**: ExternalDNS
- **Monitoring**: Prometheus + Grafana
- **Database**: PostgreSQL 15 (RDS)

---

## Automated Certificate Management

### cert-manager

cert-manager automates SSL/TLS certificate issuance and renewal using Let's Encrypt, eliminating manual certificate management.

**How it Works**:
1. NGINX Ingress resources are annotated with certificate requirements
2. cert-manager detects the annotation and requests a certificate from Let's Encrypt
3. Let's Encrypt validates domain ownership via HTTP-01 challenge
4. Certificate is issued and stored as a Kubernetes secret
5. cert-manager automatically renews certificates before expiration

**Benefits**:
- Zero manual DNS record management
- Automatic DNS updates on application deployment
- Disaster recovery: DNS updates on failover
- GitOps-friendly: DNS managed through code


## GitOps with ArgoCD

<img width="940" height="485" alt="image" src="https://github.com/user-attachments/assets/743f1391-37a3-41c8-ad3f-02294964f226" /><img width="940" height="469" alt="image" src="https://github.com/user-attachments/assets/0a01e4c7-1624-4438-beb9-efd4711f8af0" />



ArgoCD implements GitOps continuous deployment, treating Git as the single source of truth for application state.

**How it Works**:
1. Application manifests stored in Git repository
2. ArgoCD monitors repository for changes
3. Detects differences between Git state and cluster state
4. Automatically syncs changes to Kubernetes cluster
5. Provides health status and rollback capabilities

**Key Features**:
- Automated deployment on Git commit
- Declarative application definitions
- Health status monitoring
- Easy rollback to previous versions
- Audit trail of all changes

---

## Monitoring and Observability
<img width="940" height="423" alt="image" src="https://github.com/user-attachments/assets/c15f9d70-f9fc-4043-aa8a-eafa11e22ad9" /><img width="940" height="464" alt="image" src="https://github.com/user-attachments/assets/fa595e78-a4a1-4a7e-b629-7d15482383b0" /><img width="940" height="941" alt="image" src="https://github.com/user-attachments/assets/ffdddb05-12fa-4a08-9e43-018fc8217f5d" /><img width="940" height="473" alt="image" src="https://github.com/user-attachments/assets/8a6c7cb6-a4fd-4658-aacb-29db3d76eb7d" /><img width="940" height="362" alt="image" src="https://github.com/user-attachments/assets/07ef8271-ea13-4dfd-9efc-9ab9a1057942" /><img width="940" height="196" alt="image" src="https://github.com/user-attachments/assets/57f947ad-26ac-490a-a9c2-31b72a7f9c33" />







### Prometheus

Prometheus scrapes metrics from:
- Kubernetes API server and nodes
- Application pods and containers
- NGINX Ingress Controller
- System-level metrics via node-exporter

### Grafana Dashboards

Pre-configured dashboards provide insights into:
- Cluster resource utilization (CPU, memory, disk)
- Pod and deployment health
- NGINX Ingress request rates and latencies
- Application-specific metrics
- Certificate expiration monitoring

---

## CI/CD Pipeline
<img width="940" height="414" alt="image" src="https://github.com/user-attachments/assets/6aa12f97-8b9c-4150-90fc-b2a69f6857f3" /><img width="940" height="456" alt="image" src="https://github.com/user-attachments/assets/86382bb4-009d-40bc-84e4-5cd13bd44456" /><img width="940" height="371" alt="image" src="https://github.com/user-attachments/assets/ca0bcf20-7535-4b27-9b05-0efc646dddcb" />





### Terraform Infrastructure Pipeline

**Trigger**: Push or PR to `main` affecting `terraform/**`

**Workflow**:
1. **Validate**: Terraform format and syntax validation
2. **Security Scan**: Checkov analyzes Terraform for security issues
3. **Plan**: Generate execution plan (on pull requests)
4. **Apply**: Deploy infrastructure changes (on push to main)

### Application Deployment Pipeline

**Trigger**: Push to `main` affecting `applications/**`

**Workflow**:
1. **Security Scan**: Trivy scans for container vulnerabilities
2. **Deploy**: Apply Kubernetes manifests using kubectl
3. **ArgoCD Sync**: ArgoCD detects changes and syncs to cluster

### OIDC Authentication

GitHub Actions uses OpenID Connect for secure AWS authentication without storing long-lived credentials:
```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::ACCOUNT:role/github-actions-role
    aws-region: us-east-1
```

**Benefits**:
- No AWS access keys stored in GitHub
- Temporary credentials per workflow run
- Fine-grained IAM permissions
- Automatic credential rotation

---

## Project Structure
```
umami-eks-project/
├── terraform/                  # Infrastructure as Code
│   ├── modules/
│   │   ├── vpc/               # VPC, subnets, routing
│   │   ├── eks/               # EKS cluster configuration
│   │   ├── rds/               # PostgreSQL database
│   │   ├── nginx-ingress/     # NGINX controller
│   │   ├── cert-manager/      # SSL automation
│   │   ├── external-dns/      # DNS automation
│   │   ├── argocd/            # GitOps deployment
│   │   └── monitoring/        # Prometheus + Grafana
│   └── main.tf
├── applications/
│   ├── umami/helm/            # Umami Helm chart
│   └── argocd/                # ArgoCD application definitions
├── .github/workflows/
│   ├── terraform.yml          # Infrastructure pipeline
│   └── deploy-umami.yml       # Application pipeline
└── kubernetes/                # Additional manifests
```

---

## Security

**Network Security**:
- Private subnets for all application workloads
- Security groups with least-privilege rules
- Multi-AZ deployment for high availability

**Data Security**:
- RDS encryption at rest using AWS KMS
- TLS encryption in transit via Let's Encrypt
- Automated certificate rotation

**Access Control**:
- IAM roles with minimal required permissions
- OIDC authentication for GitHub Actions
- Kubernetes RBAC for pod access control

**Vulnerability Management**:
- Trivy scanning for container images
- Checkov security analysis for Terraform
- Automated dependency updates

---

## Cost Estimate

Approximately **$215-230/month**:
- EKS Control Plane: $72
- EC2 Worker Nodes (2x t3.medium): $60
- RDS PostgreSQL : $25
- Network Load Balancer: $16
- NAT Gateway: $32
- Route 53 + Storage: $10-15

---

## Key Learnings

- **Automation**: cert-manager and ExternalDNS eliminate manual operational tasks
- **GitOps**: ArgoCD provides audit trails and simplifies rollbacks through Git
- **Security**: OIDC authentication removes need for long-lived credentials
- **High Availability**: Multi-AZ deployment ensures resilience
- **Monitoring**: Prometheus and Grafana provide visibility into cluster health

---

## Future Improvements

- Implement Horizontal Pod Autoscaler for dynamic scaling
- Add centralized logging with EFK stack
- Migrate secrets to AWS Secrets Manager
- Implement network policies for enhanced security


---

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

## Contact

**Mohamed** - [GitHub](https://github.com/mohamed67471)  
**Project Repository**: [https://github.com/mohamed67471/umami-eks-project](https://github.com/mohamed67471/umami-eks-project)  

