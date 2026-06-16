# Results: las — Service & Zugriff

> Aufgabenbeschreibung: [TASKS_las.md](TASKS_las.md)  
> Datum der Durchführung: **16.06.2026**  
> Status: **Erledigt**

---

## Zusammenfassung

Der Service [`k8s/service.yaml`](k8s/service.yaml) leitet Traffic von Port **80** auf Container-Port **3000**. Endpoints sind mit beiden Pods verbunden. Zugriff im Browser funktioniert über **Port-Forward** auf http://localhost:8080 (empfohlen für kind/Demo).

---

## Task 1: Service-Manifest — Ergebnis

**Datei:** [`k8s/service.yaml`](k8s/service.yaml)

| Eigenschaft | Wert |
|-------------|------|
| Name | `web-check` |
| Typ | `NodePort` |
| Selector | `app: web-check` |
| port → targetPort | 80 → 3000 |
| nodePort | 30080 |

**Gewählte Variante:** NodePort + Port-Forward (Port-Forward ist in der Praxis am zuverlässigsten mit kind).

---

## Task 2: Service deployen — Ergebnis

**Befehle ausgeführt:**

```bash
kubectl apply -f k8s/service.yaml
kubectl get svc web-check
kubectl get endpoints web-check
```

**Ausgabe `kubectl get svc web-check`:**

```
NAME        TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
web-check   NodePort   10.96.206.39   <none>        80:30080/TCP   21s
```

**Ausgabe `kubectl get endpoints web-check`:**

```
NAME        ENDPOINTS                         AGE
web-check   10.244.0.5:3000,10.244.0.6:3000   21s
```

| Check | Status |
|-------|--------|
| Service erstellt | Ja |
| Endpoints nicht leer | Ja (2 Pod-IPs) |
| Label-Match mit lob | Ja |

---

## Task 3: Zugriff im Browser — Ergebnis

**Befehl (empfohlen für Demo):**

```bash
kubectl port-forward svc/web-check 8080:80
```

**HTTP-Test:**

```bash
curl -sI http://localhost:8080/
```

**Antwort:**

```
HTTP/1.1 302 Found
Location: /check
X-Powered-By: Express
```

| Check | Status |
|-------|--------|
| Startseite erreichbar | Ja (Redirect auf `/check`) |
| Kein Connection refused | Ja |
| URL für Demo | **http://localhost:8080** |

**Hinweis für die Schule:** Port-Forward-Terminal während der Demo offen lassen.

**NodePort-Alternative (minikube):**

```bash
minikube service web-check --url
```

Bei kind: NodePort 30080 auf Control-Plane — Port-Forward ist einfacher.

---

## Task 4: Zugriff dokumentiert — Ergebnis

Anleitung in [`k8s/README.md`](k8s/README.md), Abschnitt **Zugriff (las)**.

**Kurzbefehl für bls/Demo:**

```bash
kubectl port-forward svc/web-check 8080:80
# Browser: http://localhost:8080
```

---

## Task 5: Ingress — Ergebnis

**Nicht umgesetzt** — für das Schulprojekt nicht nötig. NodePort + Port-Forward reichen.

Optional später: `minikube addons enable ingress` + `k8s/ingress.yaml`.

---

## Task 6: Netzwerk-Fehlerbilder — Ergebnis

Dokumentiert in [`k8s/TROUBLESHOOTING.md`](k8s/TROUBLESHOOTING.md).

Bei unserem Setup traten **keine** Netzwerkfehler auf, weil:
- Labels übereinstimmten (`app: web-check`)
- `targetPort: 3000` korrekt war
- Image vor dem Deploy geladen wurde

---

## Lieferobjekte

- [x] `k8s/service.yaml` im Repo
- [x] App im Browser erreichbar (http://localhost:8080 via Port-Forward)
- [x] Zugriffs-Anleitung in `k8s/README.md`
- [ ] Ingress (optional, nicht gemacht)

---

## Präsentations-Notizen (5:00–7:00 und 12:00–14:00)

**Block 1:**
1. `kubectl get svc web-check` — Cluster-IP, NodePort 30080
2. Erkläre: Service-Port 80 → Pod-Port 3000
3. Browser öffnen: http://localhost:8080

**Block 2:** Architektur-Diagramm aus [PRÄSENTATION.md](PRÄSENTATION.md) — Browser → Service → Pods

**Merksatz:** „Der Service gibt den Pods eine stabile Adresse — auch wenn sie neu starten.“
