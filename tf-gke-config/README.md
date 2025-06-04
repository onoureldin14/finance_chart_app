# ☁️ Terraform GCP Backend Config

This Terraform module provisions essential GCP infrastructure needed to support deployments of your Streamlit app to Google Kubernetes Engine (GKE).

---

## 📦 What It Creates

This module provisions the following resources:

* 🪣 **GCS Bucket** for storing Terraform remote state with versioning enabled.
* 🐳 **Google Artifact Registry (Docker)** for storing and pushing the Streamlit Docker image.

---

## 📁 Folder Structure

```
tf-gke-config/
├── main.tf         # Core infrastructure resources
├── variables.tf    # Input variables (project_id, region, etc.)
├── outputs.tf      # Output values
└── README.md       # You're reading it!
```

---

## ✨ Usage

### 1. Prerequisites

* [Terraform](https://developer.hashicorp.com/terraform/install)
* [Google Cloud SDK](https://cloud.google.com/sdk)
* A GCP project with billing enabled
* IAM permissions to create buckets and Artifact Registry repositories

---

### 2. Initialize and Apply

```bash
cd tf-gke-config
terraform init
terraform apply
```

### Required Inputs:

Make sure to provide these variables (via `terraform.tfvars` or CLI):

```hcl
project_id = "your-gcp-project-id"
region     = "europe-west1"  # or any other supported GCP region
```

---

## 🔐 Security

* GCS bucket uses **uniform bucket-level access** for centralized permission control.
* Terraform state versioning is enabled for audit and recovery.

---

## 📤 Output

On successful apply, Terraform will output:

* The name of the GCS bucket used for Terraform remote state
* The name of the Artifact Registry repo used for Docker image storage

---

## 🧹 Cleanup

To delete all resources created:

```bash
terraform destroy
```

---

## 📚 References

* [GCS Backend for Terraform](https://developer.hashicorp.com/terraform/language/settings/backends/gcs)
* [Google Artifact Registry](https://cloud.google.com/artifact-registry/docs/docker/quickstart)
* [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
