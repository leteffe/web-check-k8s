# Web-Check auf Kubernetes

Dieses Repository dokumentiert ein **Gruppenprojekt**, in dem wir die Open-Source-Anwendung [Web-Check](https://web-check.xyz) containerisiert und auf Kubernetes bereitgestellt haben.

Der öffentliche Umfang ist bewusst klein gehalten: Docker-Image, Kubernetes-Manifeste, lokale Startanleitung und anonymisierte Projektartefakte. Es enthält keine Zugangsdaten, persönlichen Pfade oder Angaben zu einer externen Kurs- bzw. Cluster-Infrastruktur.

## Projektumfang

- Web-Check als Docker-Container bauen
- Deployment mit zwei replizierten Pods erstellen
- Service für den Zugriff auf Port 3000 bereitstellen
- Health-Checks sowie CPU- und Speicherlimits konfigurieren
- Deployment und Skalierung lokal mit `kind` prüfen

## Herkunft der Anwendung

Web-Check wurde ursprünglich von [Alicia Sykes](https://github.com/lissy93/web-check) veröffentlicht und steht unter der MIT-Lizenz. Die Lizenz und Urheberhinweise bleiben in diesem Repository erhalten. Unser Gruppenprojekt betrifft die Containerisierung und Kubernetes-Bereitstellung.

## Architektur

```text
Browser → Port-Forward :8080 → Service :80 → Pods :3000 → Docker-Image
```

Weitere Details: [KUBERNETES_ARCHITEKTUR.md](KUBERNETES_ARCHITEKTUR.md)

## Lokal starten

Voraussetzungen: Docker, `kubectl` und [kind](https://kind.sigs.k8s.io/).

```bash
kind create cluster --name web-check
docker build -t web-check:local .
kind load docker-image web-check:local --name web-check
kubectl apply -f k8s/
kubectl wait --for=condition=available deployment/web-check --timeout=180s
kubectl port-forward svc/web-check 8080:80
```

Danach ist die App unter <http://localhost:8080> erreichbar. Das Terminal mit dem Port-Forward muss geöffnet bleiben.

Alternativ übernimmt `./start.sh` diese Schritte für einen lokalen `kind`-Cluster.

## Projektdateien

| Pfad | Zweck |
|---|---|
| [Dockerfile](Dockerfile) | Build der Anwendung als Container-Image |
| [k8s/deployment.yaml](k8s/deployment.yaml) | Deployment, Replikate, Ressourcen und Health-Checks |
| [k8s/service.yaml](k8s/service.yaml) | Service für den Zugriff auf die Pods |
| [k8s/README.md](k8s/README.md) | Kurzanleitung für das Deployment |
| [KUBERNETES_PROJEKTPLAN.md](KUBERNETES_PROJEKTPLAN.md) | Anonymisierte Arbeitspakete |
| [DEMO_SKRIPT.md](DEMO_SKRIPT.md) | Kompakter Ablauf für eine Demo |
| `TASKS_*.md` und `RESULTS_*.md` | Projektartefakte und Testergebnisse |

## Aufräumen

```bash
kubectl delete -f k8s/
kind delete cluster --name web-check
```

## Hinweise für Veröffentlichungen

- Keine `.env`-, Kubeconfig- oder Zertifikatsdateien committen.
- Für eigene Deployments nur eigene Domains, Registries und Zugänge verwenden.
- Vor einem Push die Git-Historie auf personenbezogene Commit-Metadaten prüfen.
