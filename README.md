# GCP DevOps Engineer Technical Test

## Overview

This repository contains a complete DevOps implementation on Google Cloud:

- Custom VPC
- Public and private subnets
- Cloud SQL for PostgreSQL using private IP
- Cloud Run application
- Artifact Registry
- Terraform Infrastructure as Code
- GitHub Actions CI/CD
- Cloud Monitoring uptime check
- Five-minute availability alert
- Theoretical and troubleshooting answers

## Architecture

```text
Developer
   |
   | Push to main
   v
GitHub Actions
   |
   | Workload Identity Federation
   | Build and push image
   v
Artifact Registry
   |
   | Deploy revision
   v
Cloud Run
   |
   | Direct VPC egress
   v
Cloud SQL PostgreSQL

Cloud Monitoring
   |
   | Check /healthz every 60 seconds
   v
Email Alert
