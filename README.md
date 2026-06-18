Project Overview

Architecture

Docker Design Decisions
- Multi-stage build
- Non-root user
- Slim image

Kubernetes Design Decisions
- Deployment
- Service
- Readiness probe
- Liveness probe
- Resource requests/limits

CI/CD
- GitHub Actions
- Trivy vulnerability scanning
- Image push

Observability
- Prometheus metrics endpoint
- Alert rule

Trade-offs
- Local Kind cluster used
- Minimal Flask service used

Future Improvements
- HPA
- NetworkPolicy
- ArgoCD
- Grafana dashboards
- Cosign signing
- SBOM generation
