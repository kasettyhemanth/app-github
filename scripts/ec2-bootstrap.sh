#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-app}"
APP_USER="${APP_USER:-springapp}"
APP_DIR="${APP_DIR:-/opt/${APP_NAME}}"
SERVICE_NAME="${SERVICE_NAME:-${APP_NAME}}"
JAVA_PACKAGE_DEBIAN="${JAVA_PACKAGE_DEBIAN:-openjdk-21-jre-headless}"
JAVA_PACKAGE_RHEL="${JAVA_PACKAGE_RHEL:-java-21-amazon-corretto-headless}"

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y "${JAVA_PACKAGE_DEBIAN}" curl
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y "${JAVA_PACKAGE_RHEL}" curl
elif command -v yum >/dev/null 2>&1; then
  sudo yum install -y "${JAVA_PACKAGE_RHEL}" curl
else
  echo "Unsupported package manager" >&2
  exit 1
fi

if ! id -u "${APP_USER}" >/dev/null 2>&1; then
  NOLOGIN_SHELL="$(command -v nologin || echo /usr/sbin/nologin)"
  sudo useradd --system --create-home --shell "${NOLOGIN_SHELL}" "${APP_USER}"
fi

sudo mkdir -p "${APP_DIR}"
sudo chown -R "${APP_USER}:${APP_USER}" "${APP_DIR}"

sudo tee "/etc/systemd/system/${SERVICE_NAME}.service" >/dev/null <<EOF
[Unit]
Description=${APP_NAME} Spring Boot application
After=network.target

[Service]
User=${APP_USER}
WorkingDirectory=${APP_DIR}
ExecStart=/usr/bin/java -jar ${APP_DIR}/app.jar
SuccessExitStatus=143
Restart=always
RestartSec=5
Environment=SPRING_PROFILES_ACTIVE=default

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable "${SERVICE_NAME}"
