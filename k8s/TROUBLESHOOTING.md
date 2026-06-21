# Troubleshooting – Web-Check auf Kubernetes

| Symptom | Ursache | Lösung |
|---|---|---|
| `ImagePullBackOff` | Das lokale Image ist nicht im kind-Cluster. | `kind load docker-image web-check:local --name web-check` erneut ausführen. |
| `CrashLoopBackOff` | Der Container konnte nicht starten. | `kubectl logs -l app=web-check --tail=100` prüfen; bei Bedarf Ressourcen des Clusters erhöhen. |
| Pod bleibt `Pending` | Zu wenig CPU oder Speicher im Cluster. | `kubectl describe pod -l app=web-check` ausführen und den Cluster mit mehr Ressourcen starten. |
| Keine Endpoints | Service-Selector und Pod-Labels passen nicht zusammen. | `kubectl get pods --show-labels` prüfen; beide Seiten verwenden `app: web-check`. |
| Browser nicht erreichbar | Port-Forward läuft nicht. | `kubectl port-forward svc/web-check 8080:80` starten und offen lassen. |
| Readiness-Probe schlägt fehl | Die Anwendung benötigt noch Startzeit. | Logs prüfen und bei Bedarf die `initialDelaySeconds` erhöhen. |

## Diagnosebefehle

```bash
kubectl get all -l app=web-check
kubectl describe pod -l app=web-check
kubectl logs -l app=web-check --tail=100
kubectl get endpoints web-check
```
