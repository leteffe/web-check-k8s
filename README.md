# Web-Check auf Kubernetes — Schulprojekt

Die [Web-Check](https://web-check.xyz)-App (OSINT-Tool zur Website-Analyse) läuft in diesem Repo containerisiert auf **Kubernetes**.

**Team:** **lad** · **lob** · **las** · **bls**

**GitHub:** [github.com/leteffe/web-check-k8s](https://github.com/leteffe/web-check-k8s)

**Live (Kurs-Cluster):** [course-7.network.garden/check](https://course-7.network.garden/check)

---

## Voraussetzungen

| Tool | Installation (macOS) | Prüfen |
|------|----------------------|--------|
| **Docker Desktop** | [docker.com](https://www.docker.com/products/docker-desktop/) | `docker info` |
| **kubectl** | `brew install kubectl` | `kubectl version --client` |
| **kind** | `brew install kind` | `kind version` |

Docker Desktop muss **laufen**, bevor du startest.

---

## Repo klonen (erstes Mal)

```bash
git clone https://github.com/leteffe/web-check-k8s.git
cd web-check-k8s
chmod +x start.sh
./start.sh
```

Das Skript erledigt automatisch:

1. Docker prüfen  
2. kind-Cluster `web-check` erstellen (einmalig)  
3. Docker-Image bauen (`web-check:local`, dauert ca. 5–10 Min)  
4. Image ins Cluster laden  
5. Kubernetes-Manifeste deployen  
6. Port-Forward starten  

**Ausführliche Erklärung jedes Schritts:** [START_SH.md](START_SH.md)

**Auf dem Kurs-Cluster (öffentliche URL):** [NETWORK_GARDEN.md](NETWORK_GARDEN.md) → https://course-7.network.garden/check

**App im Browser (lokal):** http://localhost:8080  

Das Terminal mit Port-Forward **offen lassen** (Beenden mit `Ctrl+C`).

---

## Nach Neustart (Mac / Docker neu gestartet)

Cluster und Image existieren meist noch — kein vollständiger Neuaufbau nötig:

```bash
cd web-check-k8s
./start.sh
```

Oder manuell:

```bash
# Docker Desktop starten, dann:
cd web-check-k8s

docker start web-check-control-plane 2>/dev/null || kind start cluster --name web-check
kind load docker-image web-check:local --name web-check

kubectl config use-context kind-web-check
kubectl apply -f k8s/
kubectl wait --for=condition=available deployment/web-check --timeout=180s

lsof -ti:8080 | xargs kill 2>/dev/null   # falls Port belegt
kubectl port-forward svc/web-check 8080:80
# → http://localhost:8080
```

---

## Frische Installation (alles von Null)

Wenn du Cluster und Image komplett neu aufsetzen willst:

```bash
cd web-check-k8s

# Altes aufräumen (optional)
kubectl delete -f k8s/ --ignore-not-found
kind delete cluster --name web-check

# Neu starten
./start.sh
```

---

## Nur App lokal testen (ohne Kubernetes)

```bash
docker build -t web-check:local .
docker run --rm -p 3000:3000 web-check:local
# → http://localhost:3000
```

---

## Nützliche Befehle

```bash
# Status
kubectl get all -l app=web-check

# Logs
kubectl logs -l app=web-check --tail=50

# Skalierung (Demo)
kubectl scale deployment web-check --replicas=3
kubectl scale deployment web-check --replicas=2

# Aufräumen (App aus Cluster entfernen)
kubectl delete -f k8s/
```

---

## Projekt-Dokumentation

| Datei | Inhalt |
|-------|--------|
| [KUBERNETES_PROJEKTPLAN.md](KUBERNETES_PROJEKTPLAN.md) | Gesamtplan & Aufgabenverteilung |
| [TASKS_lad.md](TASKS_lad.md) · [RESULTS_lad.md](RESULTS_lad.md) | Docker & Image |
| [TASKS_lob.md](TASKS_lob.md) · [RESULTS_lob.md](RESULTS_lob.md) | Deployment & Pods |
| [TASKS_las.md](TASKS_las.md) · [RESULTS_las.md](RESULTS_las.md) | Service & Zugriff |
| [TASKS_bls.md](TASKS_bls.md) · [RESULTS_bls.md](RESULTS_bls.md) | Tests & Demo |
| [PRÄSENTATION.md](PRÄSENTATION.md) | Folien & Sprechertexte (10–15 Min) |
| [DEMO_SKRIPT.md](DEMO_SKRIPT.md) | Live-Demo-Ablauf |
| [START_SH.md](START_SH.md) | Erklärung von `start.sh` (Schritt für Schritt) |
| [NETWORK_GARDEN.md](NETWORK_GARDEN.md) | Deploy auf **course-7.network.garden** |
| [KUBERNETES_ARCHITEKTUR.md](KUBERNETES_ARCHITEKTUR.md) | Pods, Services, HTTPRoute — Diagramme |
| [k8s/README.md](k8s/README.md) | Kubernetes-Details |
| [k8s/TROUBLESHOOTING.md](k8s/TROUBLESHOOTING.md) | Fehlerbehebung |

---

## Häufige Probleme

| Problem | Lösung |
|---------|--------|
| `Docker daemon not running` | Docker Desktop starten |
| `address already in use` (8080) | `lsof -ti:8080 \| xargs kill` dann Port-Forward neu |
| `ImagePullBackOff` | `kind load docker-image web-check:local --name web-check` |
| Pods `Pending` / `CrashLoopBackOff` | `kubectl describe pod -l app=web-check` — siehe [k8s/TROUBLESHOOTING.md](k8s/TROUBLESHOOTING.md) |
| `kind: command not found` | `brew install kind` |

---

## Architektur (Kurz)

```
Browser → Port-Forward :8080 → Service :80 → Pods :3000 → Image web-check:local
```

Manifeste: [`k8s/deployment.yaml`](k8s/deployment.yaml) · [`k8s/service.yaml`](k8s/service.yaml)
