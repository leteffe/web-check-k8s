#!/usr/bin/env bash
# Web-Check auf Kubernetes starten (nach Neustart oder erstem Mal)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

echo "=== 1/5 Docker prüfen ==="
if ! docker info >/dev/null 2>&1; then
  echo "Docker läuft nicht. Bitte Docker Desktop starten und erneut ausführen."
  exit 1
fi

echo "=== 2/5 Kubernetes-Cluster (kind) ==="
if kind get clusters 2>/dev/null | grep -qx web-check; then
  echo "Cluster 'web-check' vorhanden — starte …"
  docker start web-check-control-plane 2>/dev/null || kind start cluster --name web-check
else
  echo "Cluster 'web-check' wird erstellt (einmalig, dauert ~1 Min) …"
  kind create cluster --name web-check
  echo "Image wird gebaut (kann mehrere Minuten dauern) …"
  docker build -t web-check:local .
  kind load docker-image web-check:local --name web-check
fi

echo "=== 3/5 Image ins Cluster laden ==="
if docker image inspect web-check:local >/dev/null 2>&1; then
  kind load docker-image web-check:local --name web-check
else
  echo "Image web-check:local fehlt — baue …"
  docker build -t web-check:local .
  kind load docker-image web-check:local --name web-check
fi

echo "=== 4/5 Deploy ==="
kubectl config use-context kind-web-check
kubectl apply -f k8s/
kubectl wait --for=condition=available deployment/web-check --timeout=180s
kubectl get pods -l app=web-check

echo "=== 5/5 Port-Forward ==="
if lsof -ti:8080 >/dev/null 2>&1; then
  echo "Port 8080 belegt — beende alten Prozess …"
  lsof -ti:8080 | xargs kill 2>/dev/null || true
  sleep 1
fi

echo ""
echo "App: http://localhost:8080"
echo "Beenden: Ctrl+C"
echo ""

kubectl port-forward svc/web-check 8080:80
