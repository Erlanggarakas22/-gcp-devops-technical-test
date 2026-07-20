# Theoretical Questions

## 1. Cloud Run, Compute Engine, and GKE

Cloud Run is a fully managed serverless platform for running stateless
containers without managing servers or Kubernetes clusters. Compute Engine
provides virtual machines with full control over the operating system,
networking, software, and runtime. GKE is a managed Kubernetes platform for
container orchestration, complex microservices, and workloads requiring
Kubernetes features. I would choose Cloud Run for stateless APIs and
applications with variable traffic. I would choose Compute Engine for legacy
applications or workloads requiring full operating-system access. I would
choose GKE for multi-service platforms requiring advanced scheduling,
networking, and Kubernetes-native deployment strategies.

## 2. Infrastructure as Code

Infrastructure as Code is the practice of defining and managing
infrastructure through version-controlled configuration files instead of
manual console operations. Tools such as Terraform make deployments
repeatable and consistent across environments. IaC reduces configuration
drift and human error because the desired infrastructure state is documented
in code. Changes can be reviewed through pull requests before being applied.
It also enables automation, faster provisioning, and standardized
environments. Terraform state and sensitive variables must still be stored
and protected securely.

## 3. Secure CI/CD IAM

I would use a dedicated deployment service account and apply the principle
of least privilege. The pipeline should only receive permissions required to
push images, deploy Cloud Run revisions, and use the Cloud Run runtime service
account. I would use Workload Identity Federation rather than storing a
long-lived service-account key in GitHub. Access should be restricted to the
intended GitHub repository and protected branches or environments. The
runtime and deployment identities should be separate. IAM and pipeline
activity should also be audited through Cloud Audit Logs.

## 4. Cloud Run Autoscaling Latency

I would review request latency, instance count, CPU, memory, concurrency,
startup duration, and application logs. I would determine whether spikes are
caused by cold starts, slow initialization, database connection creation, or
downstream dependencies. I would optimize the container image and startup
process and configure minimum instances when consistently low latency is
required. I would tune concurrency, CPU, memory, maximum instances, and
database connection pooling. Cloud SQL connection limits must be reviewed
because rapid scaling can create too many connections. Finally, I would run
load tests and compare metrics before and after each change.

## 5. Monitoring and Logging

Monitoring collects numerical metrics such as request count, latency, CPU,
memory, availability, and error rate. Logging records detailed application,
platform, and infrastructure events. In GCP, I would use Cloud Monitoring for
dashboards, uptime checks, service indicators, and alert policies. I would
use Cloud Logging for structured application and Cloud Run platform logs.
Logs can be converted into log-based metrics when specific events must
trigger alerts. Both should use common labels such as service, revision,
environment, trace ID, and severity.
EOF
