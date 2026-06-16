# Web-Check auf Kubernetes

Kurzanleitung für das Schulprojekt. Ausführliche Ergebnisse: siehe `RESULTS_*.md` im Repo-Root.

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

## Alles auf einmal

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
