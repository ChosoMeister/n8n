# n8n Enterprise Docker Build Workflow

This repository contains a GitHub Actions workflow that automatically builds and pushes n8n Docker images to GitHub Container Registry (GHCR).

## Workflow Overview

The workflow (`.github/workflows/build.yml`) performs the following steps:

1. **Clone n8n Repository**: Clones the official n8n repository from `https://github.com/n8n-io/n8n`
2. **Setup Environment**: Installs Node.js 22 and pnpm package manager
3. **Install Dependencies**: Runs `pnpm install --frozen-lockfile`
4. **Build Project**: Executes `pnpm run build`
5. **Build Docker Image**: Runs `pnpm run build:docker`
6. **Push to GHCR**: Tags and pushes the image to the repository owner's namespace (for example, `ghcr.io/<github-user>/n8n:enterprise`)

## Triggers

The workflow runs on manual dispatch from the GitHub Actions UI (`workflow_dispatch`).

## Docker Image Tags

The workflow creates multiple tags for the Docker image in the current repository owner's namespace:
- `ghcr.io/<github-user>/<repo-name>:enterprise` - Main enterprise tag
- `ghcr.io/<github-user>/<repo-name>:latest` - Latest build (only on the default branch)
- `ghcr.io/<github-user>/<repo-name>:<commit-sha>` - Specific commit version from this repository
- `ghcr.io/<github-user>/<repo-name>:n8n-<n8n-commit-hash>` - Specific n8n source repository commit version

## Required Permissions

The workflow requires the following permissions (already configured):
- `contents: read` - To checkout the repository
- `packages: write` - To push Docker images to GHCR

## Authentication

The workflow uses the `GITHUB_TOKEN` automatically provided by GitHub Actions. No additional secrets need to be configured for GHCR access.

## Usage

1. Open the **Actions** tab in your repository and select the workflow
2. Use **Run workflow** to trigger a build of the n8n Docker image
3. On successful completion, the image will be available at `ghcr.io/<github-user>/<repo-name>:enterprise`

## Pulling the Image

To use the built Docker image:

```bash
docker pull ghcr.io/<github-user>/<repo-name>:enterprise
docker run -d --name n8n -p 5678:5678 ghcr.io/<github-user>/<repo-name>:enterprise
```

## Troubleshooting

- Check the Actions tab in your GitHub repository for build logs
- Ensure your repository has Actions enabled
- Verify that the GitHub Container Registry is accessible from your account
- Make sure the repository visibility allows package publishing

## Monitoring

The workflow includes cleanup steps to prevent disk space issues and provides detailed logging for each build step.
