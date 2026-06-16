# Aufgaben: lad — Docker & Image

> Übersicht für das ganze Team: [KUBERNETES_PROJEKTPLAN.md](KUBERNETES_PROJEKTPLAN.md)

**Rolle:** Container-Image bauen, lokal testen und für Kubernetes bereitstellen.  
**Du blockierst:** lob (braucht ein lauffähiges Image `web-check:local`).  
**Geschätzte Zeit:** 1–2 Stunden

---

## Voraussetzungen

- [ ] Docker installiert (`docker --version`)
- [ ] Kubernetes-Umgebung gewählt (minikube, kind oder Docker Desktop)
- [ ] Repo geklont, im Projektroot (`web-check-k8s`)

---

## Task 1: Dockerfile verstehen

**Ziel:** Du kannst in 2–3 Sätzen erklären, wie das Image gebaut wird.

- [ ] [`Dockerfile`](Dockerfile) lesen
- [ ] Notieren: Node-Version (**22**), Build-Stage vs. Final-Stage
- [ ] Notieren: Chromium/Puppeteer-Umgebungsvariablen (`CHROME_PATH`, `PUPPETEER_EXECUTABLE_PATH`)
- [ ] Notieren: App-Start (`CMD ["yarn", "start"]`) und Port (**3000**)

**Abnahme:** Du kannst dem Team erklären, warum das Image gross ist (Chromium) und welcher Port exposed wird.

---

## Task 2: Image bauen

**Ziel:** Lokales Image `web-check:local` existiert.

```bash
cd /pfad/zu/web-check-k8s
docker build -t web-check:local .
```

- [ ] Build starten (kann 5–15 Minuten dauern)
- [ ] Bei Fehlern: Log lesen, Team informieren
- [ ] Erfolg prüfen: `docker images | grep web-check`

**Abnahme:** `docker images` zeigt `web-check` mit Tag `local`.

---

## Task 3: Container lokal testen

**Ziel:** App läuft ausserhalb von Kubernetes und ist im Browser erreichbar.

```bash
docker run --rm -p 3000:3000 web-check:local
```

- [ ] Container startet ohne sofortigen Absturz
- [ ] Browser öffnen: http://localhost:3000
- [ ] Startseite von Web-Check wird angezeigt
- [ ] Optional: eine Test-Domain analysieren (z. B. `example.com`)
- [ ] Container mit `Ctrl+C` stoppen

**Abnahme:** Screenshot oder kurze Notiz „App läuft lokal auf Port 3000“.

---

## Task 4: Image für Kubernetes verfügbar machen

**Ziel:** Das Cluster kann das Image pullen/laden — kein `ImagePullBackOff` für lob.

### Option A — minikube (empfohlen für Schulprojekt)

```bash
minikube start
eval $(minikube docker-env)
docker build -t web-check:local .
```

Image wird direkt in minikubes Docker-Daemon gebaut.

### Option B — Image nachträglich laden

```bash
docker build -t web-check:local .
minikube image load web-check:local
```

### Option C — Docker Desktop Kubernetes

Image lokal bauen; Docker Desktop nutzt oft denselben Daemon — `imagePullPolicy: IfNotPresent` im Deployment (lob setzt das).

- [ ] Gewählte Option dokumentieren
- [ ] Mit lob testen: Deployment startet ohne Image-Fehler

**Abnahme:** `kubectl describe pod` zeigt kein `ErrImagePull` / `ImagePullBackOff`.

---

## Task 5: Build-Doku für das Team schreiben

**Ziel:** Andere können das Image ohne dich nachbauen.

Erstelle oder ergänze [`k8s/README.md`](k8s/README.md) mit Abschnitt **„Image bauen (lad)“**:

```markdown
## Image bauen (lad)

# Standard-Build
docker build -t web-check:local .

# Lokal testen
docker run --rm -p 3000:3000 web-check:local

# minikube: Image im Cluster-Daemon bauen
eval $(minikube docker-env)
docker build -t web-check:local .
```

- [ ] Befehle eingetragen
- [ ] Hinweis auf Port **3000** und Image-Name `web-check:local`
- [ ] Team in Chat/Meeting informieren: „Image ist bereit“

**Abnahme:** lob kann allein das Image nach Anleitung bauen.

---

## Lieferobjekte (Checkliste)

- [ ] Image `web-check:local` gebaut
- [ ] Lokaler Test auf http://localhost:3000 erfolgreich
- [ ] Image im Kubernetes-Cluster nutzbar
- [ ] Build-Schritte in `k8s/README.md` dokumentiert

---

## Präsentation (dein Teil, ca. 1,5 Min)

**Zeitfenster:** 1:30–3:00 (siehe Hauptplan)

Vorbereiten:

1. **Warum Container?** — gleiche Umgebung überall, Abhängigkeiten (Node, Chromium) eingepackt
2. **Kurz Dockerfile zeigen** — Multi-Stage, Port 3000
3. **Live oder Screenshot:** `docker run -p 3000:3000 web-check:local`

**Satz zum Merken:** „Aus dem Dockerfile wird das Image `web-check:local` — das ist die Vorlage für jeden Pod im Cluster.“

---

## Hilfe bei Problemen

| Problem | Mögliche Lösung |
|---------|-----------------|
| Build schlägt bei `yarn install` fehl | Netzwerk prüfen, erneut bauen |
| Port 3000 belegt | Anderen Prozess beenden oder `-p 3001:3000` zum Testen |
| lob: ImagePullBackOff | Task 4 wiederholen, `eval $(minikube docker-env)` vor Build |
| App startet, Seite leer | Logs: `docker logs <container-id>` |

**Ansprechpartner im Team:** lob (Deployment), las (Netzwerk/Zugriff)
