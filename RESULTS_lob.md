# Results: lob — Deployment & Pods

> Aufgabenbeschreibung: [TASKS_lob.md](TASKS_lob.md)  
> Datum der Durchführung: **16.06.2026**  
> Status: **Erledigt**

---

## Zusammenfassung

Das Deployment [`k8s/deployment.yaml`](k8s/deployment.yaml) wurde erstellt und auf dem kind-Cluster angewendet. **2 Pods** laufen stabil mit Readiness/Liveness-Probes und Ressourcen-Limits. Skalierung auf 3 und zurück auf 2 wurde erfolgreich getestet.

---

## Task 1: Deployment-Manifest — Ergebnis

**Datei:** [`k8s/deployment.yaml`](k8s/deployment.yaml)

| Eigenschaft | Wert |
|-------------|------|
| Name | `web-check` |
| Replicas | 2 |
| Image | `web-check:local` |
| imagePullPolicy | `IfNotPresent` |
| containerPort | 3000 |
| Label | `app: web-check` |
| Resources | requests 512Mi/250m, limits 1Gi/500m |
| Probes | readiness + liveness auf `/` Port 3000 |

---

## Task 2: Deployment anwenden — Ergebnis

**Befehle ausgeführt:**

```bash
kubectl config use-context kind-web-check
kubectl apply -f k8s/deployment.yaml
kubectl wait --for=condition=available deployment/web-check --timeout=180s
```

**Ausgabe `kubectl get pods -l app=web-check`:**

```
NAME                        READY   STATUS    RESTARTS   AGE
web-check-658cfddf9-9vckt   1/1     Running   0          21s
web-check-658cfddf9-pmhff   1/1     Running   0          21s
```

**Ausgabe `kubectl get deployments`:**

```
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
web-check   2/2     2            2           21s
```

| Check | Status |
|-------|--------|
| Deployment Available | Ja (nach ~19s) |
| ImagePullBackOff | Nein |
| CrashLoopBackOff | Nein |
| Beide Pods Ready | Ja |

---

## Task 3: Ressourcen-Limits — Ergebnis

Limits und Requests sind im Manifest gesetzt (siehe Task 1).

**`kubectl describe deployment web-check` (Auszug):**

```
Limits:
  cpu:     500m
  memory:  1Gi
Requests:
  cpu:         250m
  memory:      512Mi
Liveness:      http-get http://:3000/ delay=30s
Readiness:     http-get http://:3000/ delay=15s
```

---

## Task 4: Pods inspizieren — Ergebnis

**Pod-IPs (für las/Service):**

| Pod | IP | Node |
|-----|-----|------|
| web-check-658cfddf9-9vckt | 10.244.0.5 | web-check-control-plane |
| web-check-658cfddf9-pmhff | 10.244.0.6 | web-check-control-plane |

**Logs (Auszug):**

```
🚀 Web-Check is up and running at http://localhost:3000
```

Doku in [`k8s/README.md`](k8s/README.md), Abschnitt **Deployment (lob)**.

---

## Task 5: Skalierung — Ergebnis

**Befehle ausgeführt:**

```bash
kubectl scale deployment web-check --replicas=3
# → 3. Pod web-check-658cfddf9-rs7jx erschien (0/1 → 1/1 Running)

kubectl scale deployment web-check --replicas=2
# → 3. Pod wurde entfernt, 2 Pods bleiben Running
```

| Check | Status |
|-------|--------|
| Scale auf 3 | Neuer Pod erstellt |
| Scale auf 2 | Überzählige Pods beendet |
| Demo-tauglich | Ja |

**Demo-Tipp:** Einen Pod löschen und `kubectl get pods -w` zeigen — Kubernetes startet Ersatz:

```bash
kubectl delete pod <pod-name>
```

---

## Task 6: Abstimmung mit las — Ergebnis

Label `app: web-check` stimmt mit Service-Selector überein.

**Endpoints (von las bestätigt):**

```
web-check   10.244.0.5:3000,10.244.0.6:3000
```

---

## Lieferobjekte

- [x] `k8s/deployment.yaml` im Repo
- [x] 2 laufende Pods mit Label `app: web-check`
- [x] Skalierungs-Demo getestet
- [x] Deployment-Befehle in `k8s/README.md`

---

## Präsentations-Notizen (3:00–5:00 und 10:00–12:00)

**Block 1:** `kubectl get pods -l app=web-check` — erkläre Pod vs. Deployment  
**Block 2:** `kubectl scale deployment web-check --replicas=3` live

**Merksatz:** „Das Deployment hält automatisch die gewünschte Anzahl Pods — Self-Healing inklusive.“
