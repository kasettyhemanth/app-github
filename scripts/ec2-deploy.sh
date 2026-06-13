#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-app}"
APP_USER="${APP_USER:-springapp}"
APP_DIR="${APP_DIR:-/opt/${APP_NAME}}"
SERVICE_NAME="${SERVICE_NAME:-${APP_NAME}}"
ARTIFACT_NAME="${ARTIFACT_NAME:-app.jar}"
SOURCE_JAR="${SOURCE_JAR:-${APP_DIR}/${ARTIFACT_NAME}}"

sudo mkdir -p "${APP_DIR}"
sudo mv "${SOURCE_JAR}" "${APP_DIR}/app.jar"
sudo chown "${APP_USER}:${APP_USER}" "${APP_DIR}/app.jar"

sudo systemctl daemon-reload
sudo systemctl restart "${SERVICE_NAME}"
sudo systemctl --no-pager --full status "${SERVICE_NAME}"
curl --fail --silent "http://localhost:8080/health" >/dev/null
