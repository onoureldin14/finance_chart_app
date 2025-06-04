# 📊 FINANCE\_CHART\_APP

Welcome to the **Finance Chart App** project! This repository demonstrates how to deploy a Python Streamlit application that visualizes stock data using Yahoo Finance, containerized with Docker, and deployed to a Kubernetes cluster via GKE or Minikube. It also features full observability using Grafana Loki and Alloy.

This project is modularized across multiple directories:

* `py-streamlit-app`: Python Streamlit application
* `tf-gke-backend`: Terraform scripts to provision GKE and supporting infrastructure
* `tf-gke-config`: Terraform backend setup for remote state and Docker Artifact Registry
* `k8s-grafana-tutorial`: Observability stack with Minikube + Grafana Loki

> 🖼️ Bonus: A Giphy animation is included to visually demonstrate the final deployed application!

---

## 📸 Visual Preview

<p align="center">
  <img src="https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExZXA5M3YzcTNhMGJ0YW1taW84anV1eWRjOTZyNTg2N2U1aTl2YW9qMCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/n55EGV5clTLjw7KJqy/giphy.gif" alt="Streamlit App Demo" width="600">
</p>

---

## 🚦 Getting Started (Overview)

| Step | Folder                              | Description                                            |
| ---- | ----------------------------------- | ------------------------------------------------------ |
| 1    | `tf-gke-config`                     | Provision remote Terraform backend and Docker registry |
| 2    | `py-streamlit-app`                  | Build and push Docker image to GCP Artifact Registry   |
| 3    | `tf-gke-backend`                    | Provision GKE cluster on Google Cloud using Terraform  |
| 4    | `k8s-grafana-tutorial` *(optional)* | Test locally with Minikube and deploy monitoring stack |

---

## 📁 Project Structure

```text
FINANCE_CHART_APP/
├── k8s-grafana-tutorial/        # Local Minikube + Grafana Loki + Alloy monitoring setup
├── py-streamlit-app/           # Python Streamlit app with Docker support
├── tf-gke-backend/             # Terraform code to provision GKE cluster
├── tf-gke-config/              # Terraform backend and registry setup
├── .gitignore
└── .pre-commit-config.yaml     # Code quality automation
```

---

## 💻 Streamlit App

A user-friendly interface for viewing historical stock prices using Streamlit + yfinance.

* Build and run locally
* Package with Docker
* Push to GCP Artifact Registry

See [py-streamlit-app/README.md](./py-streamlit-app/README.md) for full setup.

---

## ☁️ Terraform Infrastructure

* `tf-gke-config`: Sets up remote backend using a GCS bucket and Docker Artifact Registry for image storage
* `tf-gke-backend`: Provisions the GKE cluster to host the Streamlit app

Usage instructions for each are documented in their respective folders:

* [tf-gke-config](./tf-gke-config/README.md)
* [tf-gke-backend](./tf-gke-backend/README.md)

---

## 🧪 Minikube Testing Environment

Use the `k8s-grafana-tutorial` folder to:

* Spin up Minikube for local testing
* Deploy Streamlit app in Kubernetes
* Install Grafana + Loki + Alloy for monitoring

Read the guide here: [k8s-grafana-tutorial/README.md](./k8s-grafana-tutorial/README.md)



---

## 📦 Tech Stack

* 🐍 Streamlit + yfinance
* 🐳 Docker
* ☁️ GCP (GKE, Artifact Registry, GCS)
* 🌱 Terraform
* 📈 Grafana Loki, Alloy
* ⚙️ Helm + Kubernetes + Minikube

---

## 🧹 Cleanup

To clean up resources:

* Minikube: `minikube delete`
* Terraform (GKE): `terraform destroy`

---

## 📬 Contributions & Feedback

This project is open to improvements! Issues, discussions, and pull requests are welcome. Built with 💙 by [@onoureldin14](https://github.com/onoureldin14).

---

Happy Shipping! 🚀
