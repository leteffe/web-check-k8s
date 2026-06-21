# YAML-Referenz

## `deployment.yaml`

| Feld | Wert | Bedeutung |
|---|---|---|
| `kind` | `Deployment` | Verwaltet die gewünschten Pod-Replikate. |
| `metadata.name` | `web-check` | Name des Deployments. |
| `spec.replicas` | `2` | Zwei Pods für die Demo. |
| `spec.selector.matchLabels` | `app: web-check` | Verknüpft Deployment und Pod-Template. |
| `containers[].image` | `web-check:local` | Lokal gebautes Container-Image. |
| `containers[].containerPort` | `3000` | Port der Web-Check-Anwendung. |
| `resources` | CPU und Speicher | Begrenzen und reservieren Ressourcen pro Pod. |
| `readinessProbe` | HTTP auf `/` | Nimmt einen Pod erst bei erfolgreicher Antwort in den Service auf. |
| `livenessProbe` | HTTP auf `/` | Startet den Container bei anhaltenden Fehlern neu. |

## `service.yaml`

| Feld | Wert | Bedeutung |
|---|---|---|
| `kind` | `Service` | Stabile Adresse vor den Pods. |
| `spec.type` | `NodePort` | Ermöglicht Zugriff über den Cluster-Node; für die Demo wird Port-Forward verwendet. |
| `spec.selector` | `app: web-check` | Wählt die Web-Check-Pods aus. |
| `ports[].port` | `80` | Service-Port. |
| `ports[].targetPort` | `3000` | Port im Container. |
| `ports[].nodePort` | `30080` | Fester Port im zulässigen NodePort-Bereich. |

## Zusammenhang

```text
Deployment ── erstellt Pods mit app=web-check
Service ───── selektiert Pods mit app=web-check
Port-Forward ─ verbindet localhost:8080 mit dem Service-Port 80
```

Mit folgendem Befehl lassen sich die Manifeste ohne Cluster-Verbindung prüfen:

```bash
kubectl apply --dry-run=client -f k8s/
```
