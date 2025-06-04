# 📈 Stock Viewer App

A simple Streamlit web application that displays the last month's closing prices for a given stock symbol using data from Yahoo Finance.

---

## 🧰 Features

* Enter a ticker symbol (e.g., `AAPL`, `GOOGL`)
* View interactive line chart of closing prices
* See the latest 5 rows of price data

---

## 🚀 Getting Started

### 🔧 Requirements

* Python 3.9+
* [Streamlit](https://streamlit.io/)
* [yfinance](https://pypi.org/project/yfinance/)
* [Docker](https://www.docker.com/)
* [Google Cloud SDK](https://cloud.google.com/sdk) (for deploying)

---

### ▶️ Run Locally with GCP Registery

1. Clone the repo:

   ```bash
    git clone git@github.com:onoureldin14/finance_chart_app.git
   cd app
   ```

2. Create a virtual environment and activate it:

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

4. Run the Streamlit app:

   ```bash
   streamlit run app.py
   ```

---

## ▶️ 🐳 Run Locally with Docker

### Step 1: Build the Docker Image
```bash
docker build -t streamlit-app .
```
### Step 2: Run Locally with Docker
```bash
docker run -p 8501:8501 streamlit-app
```
---
## 🐳 Build and Push Docker Image to Google Artifact Registry

### Step 1: Authenticate Docker

```bash
docker login -u onoureldin14
```

### Step 2: Build the Docker Image

```bash
docker build  -t onoureldin14/streamlit-app:latest .
```

### Step 3: Push the Docker Image

```bash
docker push onoureldin14/streamlit-app:latest
```

### Step 4 (Optional): Run Locally with Docker

```bash
docker run -p 8501:8501 onoureldin14/streamlit-app:latest
```

Then visit: [http://localhost:8501](http://localhost:8501)



---


## 🐳 Build and Push Docker Image to Google Artifact Registry

### Step 1: Authenticate Docker with Artifact Registry

```bash
gcloud auth configure-docker europe-west1-docker.pkg.dev
```

### Step 2: Build the Docker Image

```bash
docker build  --platform linux/amd64 -t europe-west1-docker.pkg.dev/security-vmt/streamlit-app-repo/streamlit-app:latest .
```

### Step 3: Push the Docker Image

```bash
docker push europe-west1-docker.pkg.dev/security-vmt/streamlit-app-repo/streamlit-app:latest
```

### Step 4 (Optional): Run Locally with Docker

```bash
docker run -p 8501:8501 europe-west1-docker.pkg.dev/security-vmt/streamlit-app-repo/streamlit-app:latest
```

Then visit: [http://localhost:8501](http://localhost:8501)

---

## 📂 File Structure

```text
.
├── app.py
├── requirements.txt
├── Dockerfile
└── README.md
```

---

## 🧾 License

MIT License. Feel free to use and modify.
