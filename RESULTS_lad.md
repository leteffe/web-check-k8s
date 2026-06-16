# Results: lad — Docker & Image

> Aufgabenbeschreibung: [TASKS_lad.md](TASKS_lad.md)  
> Datum der Durchführung: **16.06.2026**  
> Status: **Erledigt**

---

## Zusammenfassung

Das Docker-Image `web-check:local` wurde aus dem bestehenden [`Dockerfile`](Dockerfile) gebaut, lokal getestet und in den Kubernetes-Cluster (kind) geladen. Die App antwortet mit HTTP **302** (Redirect auf `/check`) — erwartetes Verhalten.

---

## Task 1: Dockerfile verstehen — Ergebnis

| Punkt | Erkenntnis |
|-------|------------|
| Node-Version | 22 (bullseye) |
| Build | Multi-Stage: `build` (yarn install + astro build) → `final` (Chromium) |
| Port | **3000** (`EXPOSE`, App startet mit `yarn start` → `node server`) |
| Besonderheit | Chromium + Puppeteer für Website-Analysen; Image ist gross (~4.5 GB) |

**Was du in der Präsentation sagen kannst:**  
„Unser Dockerfile packt Node, die gebaute Astro-App und Chromium in ein Image — damit läuft Web-Check überall gleich.“

---

## Task 2: Image bauen — Ergebnis

**Befehl ausgeführt:**

```bash
cd web-check-k8s
docker build -t web-check:local .
```

| Metrik | Wert |
|--------|------|
| Ergebnis | Erfolg (Exit 0) |
| Dauer | ca. 7 Minuten |
| Image | `web-check:local` |
| Grösse | **4.45 GB** |
| Image-ID | `sha256:ca3d3ceb90ea...` |

**Ausgabe (Auszug):**

```
#17 naming to docker.io/library/web-check:local done
#17 unpacking to docker.io/library/web-check:local ... done
```

---

## Task 3: Container lokal testen — Ergebnis

**Befehl ausgeführt:**

```bash
docker run --rm --name web-check-test -p 3000:3000 web-check:local
```

**HTTP-Test:**

```bash
curl -sI http://localhost:3000/
```

**Antwort:**

```
HTTP/1.1 302 Found
Location: /check
X-Powered-By: Express
```

| Check | Status |
|-------|--------|
| Container startet | Ja |
| Port 3000 erreichbar | Ja |
| Web-Check Banner in Logs | Ja („Web-Check is up and running“) |

---

## Task 4: Image für Kubernetes — Ergebnis

**Umgebung:** kind-Cluster `web-check` (weil kein minikube installiert war)

**Befehle ausgeführt:**

```bash
kind create cluster --name web-check
kind load docker-image web-check:local --name web-check
```

| Check | Status |
|-------|--------|
| Cluster erstellt | Ja (`kubectl context kind-web-check`) |
| Image in Cluster geladen | Ja |
| lob: kein ImagePullBackOff | Ja — beide Pods `Running` |

**Alternative für euch (minikube):**

```bash
eval $(minikube docker-env)
docker build -t web-check:local .
```

---

## Task 5: Doku — Ergebnis

Build-Anleitung eingetragen in [`k8s/README.md`](k8s/README.md), Abschnitt **Image bauen (lad)**.

---

## Lieferobjekte

- [x] Image `web-check:local` gebaut
- [x] Lokaler Test auf http://localhost:3000 erfolgreich
- [x] Image im Kubernetes-Cluster nutzbar
- [x] Build-Schritte in `k8s/README.md` dokumentiert

---

## Präsentations-Notizen (1:30–3:00)

1. Zeige `Dockerfile` — Multi-Stage, Port 3000
2. `docker images | grep web-check` — 4.45 GB erklären (Chromium)
3. Optional: `docker run -p 3000:3000 web-check:local` + Browser

**Merksatz:** „Das Image ist die Vorlage für jeden Pod im Cluster.“
