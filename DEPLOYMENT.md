# Deployment

This project includes a GitHub Actions pipeline in `.github/workflows/ci-cd.yml`.

## What it does

1. Builds and tests the Spring Boot app with Java 21.
2. Uploads the generated jar as a workflow artifact.
3. Connects to an EC2 instance over SSH.
4. Bootstraps a clean VM by installing Java and creating a systemd service.
5. Deploys the jar and restarts the app.
6. Verifies the deployment with `GET /health`.

## Required GitHub secrets

- `EC2_HOST`
- `EC2_USER`
- `EC2_SSH_KEY`
- `EC2_PORT` (optional if not `22`)

When the EC2 IP, SSH user, port, or private key changes, update these secrets. The workflow reads them at deploy time, so no code change is needed.

## Remote layout

- App directory: `/opt/app`
- Service name: `app`
- Service user: `springapp`

These values are defined in the deploy job and can be adjusted there if needed.
