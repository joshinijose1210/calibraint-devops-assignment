# DevOps Engineer Assignment

## Project Overview

This project demonstrates containerization, Kubernetes deployment, CI/CD automation, and basic observability for a simple Python HTTP service.

The service exposes:

* `/` – application endpoint
* `/health` – health check endpoint
* `/metrics` – Prometheus metrics endpoint

## Architecture

Flask Application → Docker Container → Kubernetes Deployment → Kubernetes Service → Prometheus Scraping

## Docker Design Decisions

### Multi-stage Build

A multi-stage Docker build was used to separate dependency installation from the runtime image. This reduces the final image size and improves security.

### Non-root User

The container runs as a dedicated non-root user to follow container security best practices.

### Minimal Runtime Image

The final image uses a pinned Python slim image to reduce image size and attack surface.

### Security Updates

Operating system packages are updated during the build process to reduce known vulnerabilities identified by Trivy.

## Kubernetes Design Decisions

### Deployment

The application is deployed using a Kubernetes Deployment with two replicas for basic high availability.

### Service

A ClusterIP Service exposes the application internally within the cluster.

### Readiness Probe

The readiness probe uses the `/health` endpoint to ensure traffic is only routed to healthy pods.

### Liveness Probe

The liveness probe automatically restarts unhealthy containers.

### Resource Management

Resource requests and limits are configured to prevent resource starvation and uncontrolled resource consumption.

## CI/CD Pipeline

GitHub Actions is used to:

1. Build the Docker image
2. Run a Trivy vulnerability scan
3. Fail the pipeline on HIGH and CRITICAL vulnerabilities
4. Push the image to a container registry

## Observability

### Metrics

The service exposes Prometheus-compatible metrics through the `/metrics` endpoint.

### Alerting

A basic Prometheus alert rule is included to detect service downtime.

## Trade-offs

Given the assignment time constraints:

* A simple Flask application was used.
* Kind was used as the local Kubernetes environment.
* A basic Prometheus configuration was provided rather than a full monitoring stack.
* A single Helm chart was used for deployment simplicity.

## Future Improvements

* Horizontal Pod Autoscaler (HPA)
* Network Policies
* Pod Disruption Budgets
* ArgoCD GitOps deployment
* Grafana dashboards
* Prometheus Operator
* Cosign image signing
* SBOM generation
* Multi-environment Helm values
* Automated Helm chart testing

## Local Verification

### Build Docker Image

```bash
docker build -t http-service:v1 .
```

### Run Locally

```bash
docker run -p 8080:8080 http-service:v1
```

### Create Kubernetes Cluster

```bash
kind create cluster --name calibraint
```

### Deploy Application

```bash
helm install http-service ./helm/http-service
```

### Verify Resources

```bash
kubectl get pods
kubectl get svc
kubectl get deployment
```

### Access Service

```bash
kubectl port-forward svc/http-service 8080:80
```

### Verify Endpoints

```bash
curl localhost:8080
curl localhost:8080/health
curl localhost:8080/metrics
```
