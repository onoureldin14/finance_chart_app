# 🚀 Minikube Streamlit App + Grafana Loki Monitoring

This project sets up a full observability stack in Minikube using:

* 🧠 **Minikube** as the local Kubernetes cluster
* 📊 **Grafana + Loki** for dashboarding and log aggregation
* 📦 **Alloy** for Kubernetes monitoring
* ⚙️ **Helm** for managing Kubernetes resources
* 🐍 **Streamlit** as the sample application

---

## 📆 Prerequisites

* Linux/macOS with Bash
* Internet access
* Git and SSH access to GitHub

---

## 📁 Directory Structure

```
k8s-grafana-tutorial/
├── grafana-values.yml
├── k8s-monitoring-values.yml
├── k8s-streamlit.yaml
├── loki-values.yml
└── streamlit-app.yaml
```

---

## ⚖️ Setup Instructions

### 1. Clone the repository

```bash
git clone git@github.com:onoureldin14/finance_chart_app.git
cd finance_chart_app/k8s-grafana-tutorial
```

### 2. Make the setup script executable

```bash
chmod +x setup.sh
```

### 3. Run the setup script

```bash
./setup.sh
```

The script will:

* Install Minikube, kubectl, and Helm (if missing)
* Start Minikube (if not running)
* Enable Ingress and DNS addons
* Create required namespaces
* Deploy Loki, Grafana, and Alloy via Helm
* Deploy the Streamlit app to `prod` namespace
* Forward ports for access

---

## 🌐 Access Services

* 🔍 **Grafana**: [http://localhost:3000](http://localhost:3000)
* 💾 **Alloy UI**: [http://localhost:12345](http://localhost:12345)
* 📊 **Streamlit App**: [http://localhost:8501](http://localhost:8501)

---

## 🚮 Cleanup

To stop all port forwards and delete the Minikube cluster:

```bash
pkill -f "port-forward"
minikube delete
```

---

## 🤝 Acknowledgements

This automation is based on instructions by [@onoureldin14](https://github.com/onoureldin14).

Happy Monitoring! 🚀
