#!/bin/bash

set -e

# Emojis
CHECK="✅"
CROSS="❌"
INFO="ℹ️"
GEAR="⚙️"
ROCKET="🚀"
FOLDER="📁"
INSTALL="📦"
PORT="🌐"
REQUIRED_CPUS=8
REQUIRED_MEMORY=4013416  # 4 GB

echo "$INFO Starting Minikube setup..."

# Check if Minikube is already running
if minikube status | grep -q "host: Running"; then
    echo "$CHECK Minikube is already running."

    # Validate resources
    CPUS=$(minikube ssh -- grep -c ^processor /proc/cpuinfo)
    MEMORY=$(minikube ssh -- grep MemTotal /proc/meminfo | awk '{print $2}')

    if [ "$CPUS" -lt "$REQUIRED_CPUS" ] || [ "$MEMORY" -lt "$REQUIRED_MEMORY" ]; then
        echo "$CROSS Minikube is running but does not meet required CPU ($REQUIRED_CPUS) or Memory (${REQUIRED_MEMORY_MB}MB)."
        echo "$INFO Please run: minikube delete && ./setup.sh"
        exit 1
    fi

    # Check ingress addons and enable if not already
    for ADDON in ingress ingress-dns; do
        STATUS=$(minikube addons list | grep -E "^$ADDON\s" | awk '{print $2}')
        if [[ "$STATUS" != "enabled" ]]; then
            echo "$INFO Enabling Minikube addon '$ADDON'..."
            minikube addons enable "$ADDON"
        else
            echo "$CHECK Minikube addon '$ADDON' already enabled. Skipping."
        fi
    done
else
    echo "$INFO Starting Minikube with max CPU and memory..."
    minikube start --cpus=max --memory=max
    echo "$INFO Enabling required addons..."
    minikube addons enable ingress
    minikube addons enable ingress-dns
fi

# Check kubectl
if ! command -v kubectl &> /dev/null; then
    echo "$INSTALL kubectl not found. Installing..."
    curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl && sudo mv kubectl /usr/local/bin/
    echo "$CHECK kubectl installed."
else
    echo "$CHECK kubectl already installed."
fi

# Check helm
if ! command -v helm &> /dev/null; then
    echo "$INSTALL helm not found. Installing..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo "$CHECK helm installed."
else
    echo "$CHECK helm already installed."
fi

# Create namespaces
kubectl create namespace meta || echo "$INFO Namespace meta already exists."
kubectl create namespace prod || echo "$INFO Namespace prod already exists."

# Add and update Helm repo
helm repo add grafana https://grafana.github.io/helm-charts || echo "$INFO Grafana repo already added."
helm repo update

# Install Loki
echo "$GEAR Deploying Loki..."
helm install --values loki-values.yml loki grafana/loki -n meta  || echo "$INFO Loki already installed."

# Install Grafana
echo "$GEAR Deploying Grafana..."
helm install --values grafana-values.yml grafana grafana/grafana -n meta || echo "$INFO Grafana repo already added."

# Install Alloy (k8s-monitoring)
echo "$GEAR Deploying Alloy Monitoring..."
helm install --values k8s-monitoring-values.yml k8s grafana/k8s-monitoring -n meta || echo "$INFO Alloy already installed."

# Port-forward Grafana (background)
echo "$PORT Starting Grafana port-forward on :3000..."
echo "$INFO Waiting for Grafana pod to be ready..."
kubectl wait --namespace meta --for=condition=ready pod -l app.kubernetes.io/name=grafana --timeout=120s

POD_NAME=$(kubectl get pods --namespace meta -l "app.kubernetes.io/name=grafana" -o jsonpath="{.items[0].metadata.name}")
if [ -n "$POD_NAME" ]; then
    kubectl --namespace meta port-forward "$POD_NAME" 3000 --address 0.0.0.0 &> /dev/null &
    echo "$PORT Grafana port-forward started at :3000"
else
    echo "$CROSS Grafana pod not found. Port-forwarding skipped."
fi

# Port-forward Alloy UI (background)
echo "$PORT Starting Alloy UI port-forward on :12345..."
echo "$INFO Waiting for Alloy UI pod to be ready..."
kubectl wait --namespace meta --for=condition=ready pod -l app.kubernetes.io/name=alloy-logs --timeout=120s

POD_NAME=$(kubectl get pods --namespace meta -l "app.kubernetes.io/name=alloy-logs" -o jsonpath="{.items[0].metadata.name}")
if [ -n "$POD_NAME" ]; then
    kubectl --namespace meta port-forward "$POD_NAME" 12345 --address 0.0.0.0 &> /dev/null &
    echo "$PORT Alloy UI port-forward started at :12345"
else
    echo "$CROSS Alloy UI pod not found. Port-forwarding skipped."
fi

# Deploy Streamlit app
echo "$GEAR Deploying Streamlit App..."
kubectl apply -f k8s-streamlit.yaml -n prod

# Port-forward Streamlit app (background)
echo "$INFO Waiting for Streamlit service to be ready..."
kubectl wait --namespace prod --for=condition=available --timeout=60s deployment/streamlit || echo "$CROSS Streamlit deployment may not be ready yet."

if kubectl get svc streamlit-service -n prod > /dev/null 2>&1; then
    kubectl port-forward svc/streamlit-service -n prod 8501:80 &> /dev/null &
    echo "$PORT Streamlit app port-forward started at :8501"
else
    echo "$CROSS Streamlit service not found. Port-forwarding skipped."
fi

echo ""
echo "$ROCKET Setup complete!"
echo ""
echo "$INFO Access your services:"
echo "   - Grafana:     http://localhost:3000"
echo "   - Alloy UI:    http://localhost:12345"
echo "   - Streamlit:   http://localhost:8501"
echo ""
echo "$INFO Grafana credentials:"
echo "   - Username: admin"
echo "   - Password: adminadminadmin"
