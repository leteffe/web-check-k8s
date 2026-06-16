# Demo-Skript — Web-Check auf Kubernetes (10–15 Min)

> Präsentationsfolien: [PRÄSENTATION.md](PRÄSENTATION.md)  
> Ergebnisse: [RESULTS_bls.md](RESULTS_bls.md)

---

## Vor der Präsentation (15 Min vorher)

```bash
# Docker Desktop starten
docker info

# Cluster (falls nicht läuft)
kind create cluster --name web-check   # einmalig
kubectl config use-context kind-web-check

# Image (falls nicht vorhanden)
docker build -t web-check:local .
kind load docker-image web-check:local --name web-check

# Deploy
kubectl apply -f k8s/
kubectl wait --for=condition=available deployment/web-check --timeout=180s
kubectl get pods -l app=web-check

# Zugriff (Terminal offen lassen!)
kubectl port-forward svc/web-check 8080:80
```

- [ ] Browser-Tab: http://localhost:8080
- [ ] Zweites Terminal für `kubectl`-Befehle
- [ ] Demo-Domain notiert: **wikipedia.org**

---

## Ablauf

| Zeit | Wer | Aktion |
|------|-----|--------|
| 0:00 | **bls** | Begrüssung, Team vorstellen, Ziel erklären |
| 1:30 | **lad** | Dockerfile, `docker images`, warum Container |
| 3:00 | **lob** | `kubectl get pods`, Deployment erklären |
| 5:00 | **las** | `kubectl get svc`, Browser öffnen |
| 7:00 | **bls** | Domain analysieren, Logs zeigen |
| 10:00 | **lob** | `kubectl scale deployment web-check --replicas=3` |
| 12:00 | **las** | Architektur-Folie, Datenfluss |
| 14:00 | **bls** | Fazit, Lessons Learned, Q&A |

---

## Sprechertexte (Kurz)

### bls — 0:00
„Wir zeigen, wie die Web-Check-App in Docker verpackt und auf Kubernetes mit zwei Pods betrieben wird.“

### lad — 1:30
„Das Dockerfile baut ein Image mit Node 22 und Chromium. `docker build -t web-check:local .` — fertig ist unser Image für Kubernetes.“

### lob — 3:00
„Das Deployment sagt Kubernetes: ich will zwei Kopien. `kubectl get pods` — hier laufen sie.“

### las — 5:00
„Der Service leitet Port 80 auf die Pods weiter. Im Browser: localhost:8080.“

### bls — 7:00
„Wir geben eine Domain ein — Web-Check analysiert die Seite. Parallel: `kubectl logs` zeigt die App.“

### lob — 10:00
„`kubectl scale --replicas=3` — ein dritter Pod erscheint. Das ist Skalierung ohne Neuinstallation.“

### las — 12:00
„Browser → Service → Pods → Image. Jede Schicht hat eine Aufgabe.“

### bls — 14:00
„Kubernetes bringt Skalierung und Selbstheilung. Fragen?“

---

## Live-Befehle (zum Kopieren)

```bash
# Status
kubectl get all -l app=web-check

# Logs
kubectl logs -l app=web-check --tail=15

# Skalierung
kubectl scale deployment web-check --replicas=3
kubectl get pods -w

# Zurück
kubectl scale deployment web-check --replicas=2
```

---

## Notfall

| Problem | Lösung |
|---------|--------|
| Pods nicht Ready | `kubectl describe pod -l app=web-check` |
| Browser leer | Port-Forward neu starten |
| Kein Internet | Screenshot aus RESULTS_*.md zeigen |
| Zeit knapp | Skalierungs-Block kürzen |
