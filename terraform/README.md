# Terraform GKE Deployment

This repository contains Terraform code to provision a Google Kubernetes Engine (GKE) cluster on Google Cloud Platform (GCP).

---

## 📌 Prerequisites

* [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and authenticated
* A GCP project with billing enabled
* Sufficient IAM permissions to create GKE clusters

---

## 🚀 Usage

### 1. Setup GCP Locally (macOS)

```sh
brew install --cask google-cloud-sdk
gcloud init
gcloud auth application-default login
```

---

### 2. Clone the Repository

```sh
git clone git@github.com:onoureldin14/finance_chart_app.git
cd terraform
```

---

### 3. Initialize Remote State (GCS Backend)

This project uses remote state stored in a GCS bucket, managed under the `tf-state/` directory.

#### Steps:

```sh
cd tf-state
terraform init
terraform apply
cd ..
```

> This will create a versioned GCS bucket with a random suffix for secure and remote Terraform state storage.

---

### 4. Initialize Terraform

```sh
terraform init
```

---

### 5. Review and Customize Variables

Copy the example file and modify:

```sh
cp terraform.tfvars.example terraform.tfvars
```

Update with your project settings:

```hcl
project_id = "your-project-id"
region     = "europe-west2"
```

---

### 6. Plan the Deployment

```sh
terraform plan
```

---

### 7. Apply the Configuration

```sh
terraform apply
```

---

### 8. Access Your GKE Cluster

```sh
gcloud container clusters get-credentials <cluster-name> \
  --region <region> \
  --project <project-id>
```

---

## 🪼 Clean Up

To destroy the GKE cluster and all provisioned infrastructure:

```sh
terraform destroy
```

---

## 🪳 State Management

Terraform state is managed using a **GCS bucket** configured in the `tf-state/` folder.
This backend enables:

* Centralized state storage
* State versioning
* Team collaboration

After provisioning the state backend in `tf-state/`, Terraform will use this bucket for remote state operations.

---

## 📆 Pre-commit Hooks and Terraform Tooling

### 📅 Install Dependencies

Install all required tools using Homebrew:

```sh
brew install pre-commit terraform-docs tflint tfsec trivy checkov terrascan infracost tfupdate jq \
  minamijoyo/hcledit/hcledit
```

---

### ⚙️ Set Up Pre-commit

Install the Git hook scripts:

```sh
pre-commit install
```

Run all hooks manually:

```sh
pre-commit run --all-files
```

Included tools:

* `tflint`: Lint Terraform code
* `tfsec`, `checkov`, `terrascan`: Static analysis security scanning
* `terraform fmt`, `terraform validate`: Format and syntax check
* `terraform-docs`: Auto-generate documentation
* `trivy`: Scan for container and IaC vulnerabilities
* `infracost`: Estimate cloud cost changes
* `hcledit`: Manipulate HCL programmatically

---

## 📚 References

* [Terraform GKE Tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke)
* [GKE Documentation](https://cloud.google.com/kubernetes-engine/docs)
* [Terraform Backend - GCS](https://developer.hashicorp.com/terraform/language/settings/backends/gcs)
* [Pre-commit](https://pre-commit.com/)
