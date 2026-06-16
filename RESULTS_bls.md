# Results: bls — Tests, Troubleshooting & Präsentation

> Aufgabenbeschreibung: [TASKS_bls.md](TASKS_bls.md)  
> Datum der Durchführung: **16.06.2026**  
> Status: **Erledigt**

---

## Zusammenfassung

End-to-End-Test bestanden: Deployment, Service und Browser-Zugriff funktionieren. Troubleshooting-Doku und Demo-Skript wurden erstellt. Präsentation: siehe [PRÄSENTATION.md](PRÄSENTATION.md) und [DEMO_SKRIPT.md](DEMO_SKRIPT.md).

---

## Task 1: Vollständiges Deployment — Ergebnis

**Befehle ausgeführt:**

```bash
kubectl apply -f k8s/
kubectl wait --for=condition=available deployment/web-check --timeout=180s
kubectl get all -l app=web-check
```

| Ressource | Status |
|-----------|--------|
| Deployment `web-check` | 2/2 Available |
| Pods | 2/2 Running |
| Service `web-check` | NodePort 80:30080 |
| ReplicaSet | 2/2 Ready |

---

## Task 2: Smoke-Test — Ergebnis

| Check | Ergebnis |
|-------|----------|
| HTTP GET `/` via Port-Forward | **302** → `/check` |
| Express-Server aktiv | Ja (Header `X-Powered-By: Express`) |
| Pod-Logs | „Web-Check is up and running“ |

**Testprotokoll:**

| Feld | Wert |
|------|------|
| Datum | 16.06.2026 |
| URL | http://localhost:8080 |
| Cluster | kind-web-check |
| Getestete Route | `/` (Redirect auf `/check`) |
| Ergebnis | Erfolgreich |

**Hinweis:** Vollständige Domain-Analyse (z. B. `wikipedia.org`) im Browser während der Live-Demo zeigen — benötigt Internet und etwas Ladezeit (Puppeteer/Chromium).

---

## Task 3: kubectl-Checks — Ergebnis

Alle Befehle erfolgreich ausgeführt:

```bash
kubectl get deployments,pods,services -l app=web-check
kubectl describe deployment web-check
kubectl logs -l app=web-check --tail=20
kubectl get endpoints web-check
```

**Kurzerklärung für die Demo:**

| Befehl | Bedeutung |
|--------|-----------|
| `get pods` | Welche Instanzen laufen? |
| `get svc` | Wie erreichen wir die App? |
| `get endpoints` | Welche Pod-IPs steckt hinter dem Service? |
| `logs` | Was macht die App gerade? |

---

## Task 4: Troubleshooting-Sheet — Ergebnis

Erstellt: [`k8s/TROUBLESHOOTING.md`](k8s/TROUBLESHOOTING.md)

Beim Setup traten keine Fehler auf. Häufigste Risiken für die Schul-Demo:
1. Docker Desktop nicht gestartet
2. Image nicht im Cluster (`ImagePullBackOff`)
3. Port-Forward nicht aktiv

---

## Task 5: Demo-Skript — Ergebnis

Erstellt: [`DEMO_SKRIPT.md`](DEMO_SKRIPT.md)

---

## Task 6: Präsentation — Ergebnis

Erstellt: [`PRÄSENTATION.md`](PRÄSENTATION.md) — Folienstruktur + Sprechertexte.

---

## Task 7: Backup-Plan — Ergebnis

| Backup | Status |
|--------|--------|
| kubectl-Outputs in RESULTS_*.md | Ja |
| HTTP-Header als Nachweis | Ja (302 in RESULTS_las.md) |
| Live-Cluster reproduzierbar | Ja (`kind create cluster` + Befehle in k8s/README.md) |

**Falls Live-Demo scheitert:** RESULTS-Dateien und PRÄSENTATION.md zeigen Screenshots/Outputs; Cluster mit `kubectl apply -f k8s/` neu starten.

---

## Lieferobjekte

- [x] End-to-End-Test bestanden
- [x] Testprotokoll (oben)
- [x] `k8s/TROUBLESHOOTING.md`
- [x] `DEMO_SKRIPT.md`
- [x] `PRÄSENTATION.md`
- [x] Backup via dokumentierte Outputs

---

## Präsentations-Notizen (0:00–1:30, 7:00–10:00, 14:00–15:00)

**Du moderierst:** Begrüssung, Live-Demo im Browser, Fazit + Q&A.

**Live-Demo Checkliste am Präsentationstag:**

```
[x] Cluster läuft (kind-web-check oder minikube)
[x] kubectl get pods → 2/2 Running
[x] kubectl port-forward svc/web-check 8080:80
[x] http://localhost:8080 lädt
[ ] Demo-Domain: wikipedia.org (live im Browser)
```

**Merksatz:** „Wir betreiben dieselbe App, die in Docker lief, jetzt hochverfügbar mit zwei Pods auf Kubernetes.“
