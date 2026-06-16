# Demo-Skript — Web-Check auf Kubernetes (10–15 Min)

> Präsentationsfolien: [PRÄSENTATION.md](PRÄSENTATION.md)  
> Deploy: [NETWORK_GARDEN.md](NETWORK_GARDEN.md)

**Demo-URL:** **https://course-7.network.garden**

---

## Vor der Präsentation (15 Min vorher)

```bash
export KUBECONFIG=/Users/latifadili/mil_cyber_k8s/lad/course-7.config
kubectl config set-context --current --namespace=lab

kubectl apply -f k8s/network-garden/
kubectl rollout status deployment/web-check -n lab --timeout=180s
kubectl get pods,svc,httproute -n lab -l app=web-check
```

- [ ] Browser-Tab: **https://course-7.network.garden**
- [ ] Startseite lädt (Redirect auf `/check` ist normal)
- [ ] Zweites Terminal für `kubectl`-Befehle (kein Port-Forward nötig)
- [ ] Demo-Domain notiert: **wikipedia.org**

**Kein** `kubectl port-forward` — die App ist über die Domain erreichbar.

---

## Ablauf

| Zeit | Wer | Aktion |
|------|-----|--------|
| 0:00 | **bls** | Begrüssung, Team vorstellen, Ziel erklären |
| 1:30 | **lad** | Dockerfile, Image auf Registry, warum Container |
| 3:00 | **lob** | `kubectl get pods -n lab`, Deployment erklären |
| 5:00 | **las** | `kubectl get httproute`, Browser: course-7.network.garden |
| 7:00 | **bls** | Domain analysieren, Logs zeigen |
| 10:00 | **lob** | `kubectl scale deployment web-check -n lab --replicas=2` |
| 12:00 | **las** | Architektur-Folie (Gateway → HTTPRoute → Service) |
| 14:00 | **bls** | Fazit, GitHub, Team-Kürzel, Q&A |

---

## Sprechertexte (Kurz)

### bls — 0:00
„Wir zeigen, wie die Web-Check-App auf Kubernetes läuft — öffentlich unter course-7.network.garden. Unser Code liegt auf GitHub, umgesetzt von lad, lob, las und bls.“

### lad — 1:30
„Das Dockerfile baut ein Image mit Node 22 und Chromium. Auf dem Kurs-Cluster nutzen wir `lissy93/web-check` aus der Registry — der Cluster kann keine lokalen Images laden.“

### lob — 3:00
„Das Deployment startet den Pod im Namespace lab. `kubectl get pods -n lab` — hier läuft Web-Check.“

### las — 5:00
„Die HTTPRoute verbindet course-7.network.garden mit unserem Service. Im Browser öffnen wir https://course-7.network.garden — ohne localhost, ohne Port-Forward.“

### bls — 7:00
„Wir geben eine Domain ein — Web-Check analysiert die Seite. Parallel: `kubectl logs -n lab` zeigt die App im Cluster.“

### lob — 10:00
„`kubectl scale --replicas=2` — ein zweiter Pod erscheint. Skalierung ohne Neuinstallation.“

### las — 12:00
„Browser → Gateway → HTTPRoute → Service → Pod. Jede Schicht hat eine Aufgabe.“

### bls — 14:00
„Kubernetes auf network.garden — Team lad, lob, las, bls. Repo: github.com/leteffe/web-check-k8s. Fragen?“

---

## Live-Befehle (zum Kopieren)

```bash
export KUBECONFIG=/Users/latifadili/mil_cyber_k8s/lad/course-7.config

# Status
kubectl get all,httproute -n lab -l app=web-check

# Logs
kubectl logs -n lab -l app=web-check --tail=15

# Skalierung
kubectl scale deployment web-check -n lab --replicas=2
kubectl get pods -n lab -w

# Zurück
kubectl scale deployment web-check -n lab --replicas=1
```

---

## Notfall

| Problem | Lösung |
|---------|--------|
| Pods nicht Ready | `kubectl describe pod -n lab -l app=web-check` |
| Seite nicht erreichbar | `kubectl get httproute -n lab`; ggf. `kubectl apply -f k8s/network-garden/` |
| `connection refused` (kubectl) | `export KUBECONFIG=.../course-7.config` setzen |
| Kein Internet in Schule | Screenshot / curl-Ergebnis aus NETWORK_GARDEN.md |
| Zeit knapp | Skalierungs-Block kürzen |

---

## Lokal üben (nicht für die Schul-Präsentation)

Falls ihr vorher auf dem eigenen Rechner testen wollt:

```bash
./start.sh
# → http://localhost:8080
```

Das ist ein **anderes** Setup (kind + Port-Forward). Die **Präsentation** läuft über **https://course-7.network.garden**.
