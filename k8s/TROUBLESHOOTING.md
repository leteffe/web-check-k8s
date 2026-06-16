# Troubleshooting — Web-Check auf Kubernetes

| Fehler | Bedeutung | Verantwortlich | Lösung |
|--------|-----------|----------------|--------|
| `ImagePullBackOff` / `ErrImagePull` | Image nicht im Cluster | lad | `eval $(minikube docker-env)` und `docker build -t web-check:local .` oder `minikube image load web-check:local` |
| `CrashLoopBackOff` | Container startet nicht | lob / lad | `kubectl logs -l app=web-check`; Speicher erhöhen oder `replicas: 1` testen |
| Pod `Pending` | Keine Ressourcen auf Node | lob | `kubectl describe pod`; Cluster-RAM erhöhen oder requests senken |
| Leere Endpoints | Service findet keine Pods | las / lob | Labels prüfen: `kubectl get pods --show-labels`; Selector `app: web-check` |
| Browser: Verbindung fehlgeschlagen | Falscher Port / kein Forward | las | `kubectl port-forward svc/web-check 8080:80` |
| `connection refused` auf localhost:8080 | Port-Forward nicht aktiv | las | Terminal mit Port-Forward offen lassen |
| Readiness probe failed | App braucht länger zum Start | lob | `initialDelaySeconds` in deployment.yaml erhöhen |
| Build schlägt fehl (Docker) | Netzwerk / Architektur | lad | `docker build --platform linux/amd64 -t web-check:local .` auf Apple Silicon |

## Nützliche Befehle

```bash
kubectl get all -l app=web-check
kubectl describe pod -l app=web-check
kubectl logs -l app=web-check --tail=100
kubectl get endpoints web-check
kubectl events --sort-by='.lastTimestamp'
```
