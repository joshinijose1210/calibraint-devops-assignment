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

The final image uses the slim Python base image to reduce attack surface and image size.

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

Resource requests and limits are configured to prevent resource starvation and uncontrolled consumption.

## CI/CD Pipeline

GitHub Actions is used to:

1. Build the Docker image
2. Perform vulnerability scanning using Trivy
3. Fail on HIGH and CRITICAL vulnerabilities
4. Push the image to a container registry

## Observability

### Metrics

The service exposes Prometheus-compatible metrics via the `/metrics` endpoint.

### Alerting

A basic Prometheus alert rule is included to detect service downtime.

## Trade-offs

Given the assignment time constraints:

* A simple Flask application was used.
* Kind was used as the local Kubernetes environment.
* A basic Prometheus configuration was provided rather than a full monitoring stack.

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

## Local Verification

### Docker

```bash
docker build -t http-service:v1 .
docker run -p 8080:8080 http-service:v1
```

### Kubernetes

```bash
kind create cluster --name calibraint

helm install http-service ./helm/http-service

kubectl get pods
kubectl get svc
```

### Metrics

```bash
curl localhost:8080/metrics
```
