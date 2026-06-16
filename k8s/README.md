# Web-Check auf Kubernetes

Kurzanleitung für Kubernetes-Details. **Einstieg für das ganze Team:** [README.md](../README.md) im Repo-Root (Klonen, Neustart, `start.sh`).

Ausführliche Ergebnisse: siehe `RESULTS_*.md` im Repo-Root.

## Voraussetzungen

- Docker
- Kubernetes-Cluster (minikube, kind oder Docker Desktop → Kubernetes aktivieren)
- `kubectl`

## Image bauen (lad)

```bash
# Standard-Build
docker build -t web-check:local .

# Lokal testen
docker run --rm -p 3000:3000 web-check:local
# → http://localhost:3000

# minikube: Image im Cluster-Daemon bauen
eval $(minikube docker-env)
docker build -t web-check:local .

# Alternativ: Image laden
minikube image load web-check:local
```

## Deployment (lob)

```bash
kubectl apply -f k8s/deployment.yaml
kubectl get pods -l app=web-check
kubectl describe deployment web-check
kubectl logs -l app=web-check --tail=50

# Skalierung (Demo)
kubectl scale deployment web-check --replicas=3
kubectl scale deployment web-check --replicas=2
```

## Zugriff (las)

```bash
kubectl apply -f k8s/service.yaml
kubectl get svc web-check

# NodePort (minikube)
minikube service web-check --url

# Port-Forward (funktioniert überall)
kubectl port-forward svc/web-check 8080:80
# → http://localhost:8080
```

## Nach Neustart / täglicher Start

Siehe [README.md](../README.md) — Abschnitt **„Nach Neustart“** oder einfach:

```bash
./start.sh
```

<details>
<summary>Manuelle Befehle (aufklappen)</summary>

```bash
# 1. Docker Desktop starten, dann im Projektordner:
cd web-check-k8s

# 2. Cluster starten (falls kind bereits existiert)
docker start web-check-control-plane 2>/dev/null || kind start cluster --name web-check

# Falls Cluster noch nie erstellt:
# kind create cluster --name web-check
# docker build -t web-check:local .
# kind load docker-image web-check:local --name web-check

# 3. Image ins Cluster laden (nach jedem Rebuild)
kind load docker-image web-check:local --name web-check

# 4. Deploy & warten
kubectl config use-context kind-web-check
kubectl apply -f k8s/
kubectl wait --for=condition=available deployment/web-check --timeout=180s
kubectl get pods -l app=web-check

# 5. Alten Port-Forward beenden (falls Port belegt)
lsof -ti:8080 | xargs kill 2>/dev/null

# 6. Zugriff (Terminal offen lassen!)
kubectl port-forward svc/web-check 8080:80
# → Browser: http://localhost:8080
```

</details>

```bash
kubectl apply -f k8s/
kubectl get all -l app=web-check
kubectl wait --for=condition=available deployment/web-check --timeout=180s
kubectl port-forward svc/web-check 8080:80
```

## Aufräumen

```bash
kubectl delete -f k8s/
```

## Manifeste validieren (ohne Cluster)

```bash
kubectl apply --dry-run=client -f k8s/
```
