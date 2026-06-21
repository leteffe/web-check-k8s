# Projektplan – Web-Check auf Kubernetes

## Ziel

Web-Check wird für ein Gruppenprojekt als Docker-Container gebaut und lokal auf Kubernetes betrieben. Das Repository zeigt die dafür benötigten Manifeste und die nachvollziehbaren Prüfschritte.

## Arbeitspakete

| Arbeitspaket | Ergebnis | Status |
|---|---|---|
| Containerisierung | Reproduzierbares Image über das `Dockerfile` | erledigt |
| Deployment | Zwei Pods mit Ressourcenlimits und Health-Checks | erledigt |
| Netzwerk | Service von Port 80 auf Container-Port 3000 | erledigt |
| Test | Lokaler Zugriff, Logs und Skalierung geprüft | erledigt |
| Dokumentation | Kurzanleitung, Architektur und Demo-Ablauf | erledigt |

## Akzeptanzkriterien

- Das Docker-Image lässt sich lokal bauen.
- Das Deployment erreicht den Status `Available`.
- Der Service findet die Pods über das Label `app: web-check`.
- Die App ist per Port-Forward unter `http://localhost:8080` erreichbar.
- Ein Scale-up erzeugt zusätzliche Pods und ein Scale-down reduziert sie wieder.

## Relevante Dateien

- [Dockerfile](Dockerfile)
- [k8s/deployment.yaml](k8s/deployment.yaml)
- [k8s/service.yaml](k8s/service.yaml)
- [k8s/README.md](k8s/README.md)
- [KUBERNETES_ARCHITEKTUR.md](KUBERNETES_ARCHITEKTUR.md)

Die detaillierten Aufgaben- und Ergebnisprotokolle bleiben als Projektartefakte im Repository. Sie enthalten keine Zugangsdaten oder personenbezogenen Kontaktangaben.
