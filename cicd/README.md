# CI/CD Pipeline

## Trigger

The GitHub Actions workflow runs when application or workflow changes
are pushed to the `main` branch.

## Authentication

GitHub Actions authenticates to Google Cloud by using Workload Identity
Federation. No long-lived service-account JSON key is stored in GitHub.

## Pipeline Steps

1. Checkout the repository.
2. Authenticate to Google Cloud.
3. Configure Docker authentication for Artifact Registry.
4. Build the application container image.
5. Tag the image with the Git commit SHA.
6. Push the image to Artifact Registry.
7. Deploy the image as a new Cloud Run revision.
8. Run a smoke test against `/healthz`.

## Image Naming

Images use the following format:

`REGION-docker.pkg.dev/PROJECT_ID/REPOSITORY/IMAGE:GIT_SHA`

Using the Git commit SHA makes every deployed image traceable to
its source-code revision.
