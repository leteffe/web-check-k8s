# Präsentationsablauf – Web-Check auf Kubernetes

## Vor der Demo

```bash
kubectl apply -f k8s/
kubectl wait --for=condition=available deployment/web-check --timeout=180s
kubectl port-forward svc/web-check 8080:80
```

- Browser mit <http://localhost:8080> öffnen.
- `kubectl get pods -l app=web-check` in einem zweiten Terminal bereithalten.
- [DEMO_SKRIPT.md](DEMO_SKRIPT.md) als Ablauf verwenden.

## Kurzablauf

| Zeit | Inhalt |
|---|---|
| 0:00–2:00 | Projektziel und ursprüngliche Web-Check-Anwendung vorstellen. |
| 2:00–4:00 | Dockerfile und lokales Image erklären. |
| 4:00–6:00 | Deployment und die zwei Pods zeigen. |
| 6:00–8:00 | Service und Port-Forward erklären, Anwendung im Browser öffnen. |
| 8:00–10:00 | Skalierung demonstrieren und Ergebnis zusammenfassen. |

## Während der Skalierungsdemo

```bash
kubectl scale deployment web-check --replicas=3
kubectl get pods -l app=web-check --watch
```

Nach der Demo:

```bash
kubectl scale deployment web-check --replicas=2
```
