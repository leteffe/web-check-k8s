# Kubernetes-Deployment

Die Manifeste in diesem Ordner sind für eine lokale, reproduzierbare Demo mit `kind` vorgesehen. Sie enthalten keine Konfiguration für eine bestimmte externe Umgebung.

## Image bauen und in kind laden

```bash
kind create cluster --name web-check
docker build -t web-check:local .
kind load docker-image web-check:local --name web-check
```

## Deployment anwenden

```bash
kubectl apply -f k8s/
kubectl wait --for=condition=available deployment/web-check --timeout=180s
kubectl get pods -l app=web-check
kubectl get service web-check
```

## Lokal zugreifen

```bash
kubectl port-forward svc/web-check 8080:80
```

Anschließend ist die Anwendung unter <http://localhost:8080> verfügbar.

## Skalierung prüfen

```bash
kubectl scale deployment web-check --replicas=3
kubectl get pods -l app=web-check
kubectl scale deployment web-check --replicas=2
```

## Aufräumen

```bash
kubectl delete -f k8s/
```

Die Bedeutung der YAML-Felder steht in [YAML_REFERENZ.md](YAML_REFERENZ.md). Typische Fehlerbilder sind in [TROUBLESHOOTING.md](TROUBLESHOOTING.md) dokumentiert.
