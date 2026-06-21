# Präsentationsnotizen – Web-Check auf Kubernetes

## Kernaussage

Im Gruppenprojekt wurde die Open-Source-Anwendung Web-Check mit Docker containerisiert und auf Kubernetes bereitgestellt.

## Sinnvolle Reihenfolge

1. Ausgangslage: Web-Check ist eine Anwendung zur Analyse von Websites.
2. Container: Das `Dockerfile` erstellt ein reproduzierbares Image.
3. Deployment: Kubernetes startet und überwacht zwei Pods.
4. Service: Eine stabile interne Adresse verbindet Anfragen mit den Pods.
5. Demo: Zugriff über einen lokalen Port-Forward und Analyse einer Test-Domain.
6. Skalierung: Das Deployment auf drei Replikate erhöhen und die neuen Pods zeigen.
7. Fazit: Containerisierung und Kubernetes machen den Betrieb reproduzierbar und skalierbar.

## Belege im Repository

- [Dockerfile](Dockerfile)
- [k8s/deployment.yaml](k8s/deployment.yaml)
- [k8s/service.yaml](k8s/service.yaml)
- [KUBERNETES_ARCHITEKTUR.md](KUBERNETES_ARCHITEKTUR.md)
- [DEMO_SKRIPT.md](DEMO_SKRIPT.md)

Die Präsentation verwendet ausschließlich lokale, reproduzierbare Befehle und keine Informationen zu externen Umgebungen.
