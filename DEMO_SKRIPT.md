# Demo-Skript – Web-Check auf Kubernetes

Dieses Skript zeigt die Kernidee des Gruppenprojekts in etwa zehn Minuten: Anwendung containerisieren, auf Kubernetes deployen und über einen Service erreichbar machen.

## Vorbereitung

```bash
kubectl apply -f k8s/
kubectl wait --for=condition=available deployment/web-check --timeout=180s
kubectl get pods,svc -l app=web-check
kubectl port-forward svc/web-check 8080:80
```

Im Browser <http://localhost:8080> öffnen.

## Ablauf

| Abschnitt | Inhalt |
|---|---|
| Einführung | Ziel: Web-Check als containerisierte Anwendung auf Kubernetes betreiben. |
| Docker | `Dockerfile` zeigt den reproduzierbaren Build des Images. |
| Deployment | Zwei Pods, Ressourcenlimits und Health-Checks erklären. |
| Service | Service selektiert Pods über `app: web-check` und leitet Port 80 auf 3000 weiter. |
| Live-Test | Eine Test-Domain in Web-Check analysieren und die App-Antwort zeigen. |
| Skalierung | `kubectl scale deployment web-check --replicas=3` ausführen und neue Pods beobachten. |
| Fazit | Kubernetes hält die gewünschte Zahl Pods bereit und entkoppelt Zugriff vom einzelnen Pod. |

## Nützliche Befehle

```bash
kubectl get all -l app=web-check
kubectl logs -l app=web-check --tail=30
kubectl scale deployment web-check --replicas=3
kubectl scale deployment web-check --replicas=2
```

## Rückbau

```bash
kubectl delete -f k8s/
```
