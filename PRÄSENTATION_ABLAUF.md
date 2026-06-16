# Präsentation — Konkreter Ablauf (10–15 Min)

**Was ihr zeigt, sagt und tippt** — Schritt für Schritt für das ganze Team.

| | |
|---|---|
| **URL** | https://course-7.network.garden/check |
| **GitHub** | https://github.com/leteffe/web-check-k8s |
| **Team** | lad · lob · las · bls |
| **Cluster** | course-7 (`export KUBECONFIG=.../course-7.config`) |

> Folien-Stichworte: [PRÄSENTATION.md](PRÄSENTATION.md) · Technik: [KUBERNETES_ARCHITEKTUR.md](KUBERNETES_ARCHITEKTUR.md)

---

## Vorbereitung (15 Min vorher)

### Terminal 1 — Cluster prüfen

```bash
export KUBECONFIG=/Users/latifadili/mil_cyber_k8s/lad/course-7.config
kubectl config set-context --current --namespace=lab
kubectl apply -f k8s/network-garden/
kubectl get pods,svc,httproute -n lab -l app=web-check
```

**Erwartung:** Pod `1/1 Running`, Service `web-check-svc`, HTTPRoute `web-check-route`.

### Bildschirm vorbereiten

- [ ] **Browser-Tab 1:** https://course-7.network.garden/check (Eingabefeld sichtbar)
- [ ] **Terminal** gross genug zum Lesen (Schrift vergrössern)
- [ ] **Folien** oder dieses Dokument auf zweitem Bildschirm
- [ ] Demo-Domain notiert: **wikipedia.org**
- [ ] `KUBECONFIG` exportiert — sonst seht ihr `kind-web-check` und **kein** Namespace `lab`

### Wer hat was parat?

| Person | Bereit halten |
|--------|----------------|
| **bls** | Begrüssung, Browser-Demo, Fazit |
| **lad** | Dockerfile im Editor oder Folie |
| **lob** | Terminal mit `kubectl get pods` |
| **las** | Terminal + Browser-Tab |
| **alle** | Wissen: „Unser Namespace heisst `lab`“ |

---

## Der Ablauf — Minute für Minute

### 0:00–1:30 · bls — Einstieg

**Zeigen:** Titelfolie oder Browser mit `/check` im Hintergrund.

**Sagen:**
> „Guten Tag. Wir sind **lad, lob, las und bls**. Unser Schulprojekt: die App **Web-Check** auf **Kubernetes** betreiben.  
> Web-Check ist ein OSINT-Tool — man gibt eine Website ein und bekommt Infos wie DNS, Technologien und Headers.  
> Die App läuft bei uns öffentlich unter **course-7.network.garden/check**. Alles liegt auf GitHub: **github.com/leteffe/web-check-k8s**.“

**Optional zeigen:** GitHub-Repo kurz im Browser (README, Ordner `k8s/network-garden/`).

---

### 1:30–3:00 · lad — Docker & Image

**Zeigen:** `Dockerfile` im Repo (Zeilen: Multi-Stage, `EXPOSE 3000`, Chromium).

**Sagen:**
> „Zuerst packen wir die App in ein **Docker-Image**. Das Dockerfile baut Node.js und Chromium ein — die App braucht einen Browser für Analysen.  
> Lokal bauen wir mit `docker build -t web-check:local .` — das Image ist etwa 4 GB gross.  
> Auf dem **Kurs-Cluster** können wir kein lokales Image nutzen. Dort verwenden wir **`lissy93/web-check`** von Docker Hub — der Cluster muss das Image selbst pullen können.“

**Optional im Terminal:**
```bash
docker images | grep web-check    # nur wenn lokal gebaut
```

**Merksatz für die Klasse:** *Image = Vorlage, Pod = laufende Kopie.*

---

### 3:00–5:00 · lob — Deployment & Pods

**Zeigen:** Terminal — **gross und lesbar**.

**Tippen:**
```bash
export KUBECONFIG=/Users/latifadili/mil_cyber_k8s/lad/course-7.config
kubectl get pods -n lab -l app=web-check
```

**Sagen:**
> „In Kubernetes läuft die App in einem **Pod**. Das **Deployment** sagt: ich will eine Instanz — und hält sie am Laufen.  
> Hier seht ihr unseren Pod: Status **Running**, **1/1 Ready**.  
> Der Pod lebt im Namespace **`lab`** — das ist unser Bereich auf dem Cluster.“

**Optional:**
```bash
kubectl describe deployment web-check -n lab | head -25
```

**Zeigen:** `Replicas: 1`, `Image: lissy93/web-check`, `Liveness/Readiness` Probes.

**Kurz YAML erwähnen** (Folie oder `k8s/network-garden/deployment.yaml`):
> „Das steht in unserer **deployment.yaml**: Image, Port 3000, Speicher-Limits und Health-Checks.“

---

### 5:00–7:00 · las — Service, HTTPRoute, Browser

**Zeigen:** Terminal, dann Browser.

**Tippen:**
```bash
kubectl get svc web-check-svc -n lab
kubectl get httproute web-check-route -n lab
```

**Sagen:**
> „Der **Service** gibt den Pods eine feste Adresse im Cluster — Port **8080** intern, weiter zu Port **3000** im Container.  
> Die **HTTPRoute** verbindet unsere Domain **course-7.network.garden** mit diesem Service.  
> Das **Gateway** `traefik-gateway` — vom Kurs bereitgestellt — nimmt HTTPS auf Port 443 entgegen.“

**Dann Browser öffnen:** https://course-7.network.garden/check

**Sagen:**
> „Kein localhost, kein Port-Forward — die App ist direkt über die Domain erreichbar. Unter **/check** startet das Tool.“

**Kurz YAML** (`service.yaml` + `httproute.yaml`):
> „Service-Selector `app: web-check` — HTTPRoute zeigt auf `web-check-svc:8080`.“

---

### 7:00–10:00 · bls — Live-Demo Web-Check

**Zeigen:** Browser — volle Aufmerksamkeit.

**Machen:**
1. https://course-7.network.garden/check ist offen
2. Im Eingabefeld: **wikipedia.org** (oder `example.com` wenn Internet langsam)
3. **Analyze** klicken
4. Warten — Ergebnisse scrollen (DNS, SSL, Tech-Stack …)

**Sagen währenddessen:**
> „Das läuft jetzt auf unserem Pod im Cluster — nicht auf unserem Laptop. Chromium im Container holt die Seite und analysiert sie.“

**Parallel Terminal** (wenn Analyse läuft):
```bash
kubectl logs -n lab -l app=web-check --tail=15
```

**Sagen:**
> „In den Logs seht ihr, dass der Express-Server Anfragen bearbeitet.“

**Falls Internet langsam:** Vorher einmal analysieren, Screenshot als Backup.

---

### 10:00–12:00 · lob — Skalierung (optional, beeindruckend)

**Zeigen:** Terminal.

**Tippen:**
```bash
kubectl scale deployment web-check -n lab --replicas=2
kubectl get pods -n lab -l app=web-check -w
```

**Sagen:**
> „Mit **einem Befehl** erhöhen wir die Anzahl Pods von 1 auf 2. Kubernetes startet automatisch einen zweiten Pod — gleiche App, gleiches Image.  
> Das ist **Skalierung** ohne die App neu zu installieren.“

**Warten** bis 2 Pods `Running`, dann:
```bash
kubectl scale deployment web-check -n lab --replicas=1
```

**Optional Selbstheilung zeigen** (nur wenn Zeit):
```bash
kubectl delete pod -n lab -l app=web-check
kubectl get pods -n lab -w
```
> „Pod gelöscht — das Deployment erstellt sofort einen neuen. Das nennt man **Self-Healing**.“

---

### 12:00–14:00 · las — Architektur (Folie)

**Zeigen:** Diagramm aus [KUBERNETES_ARCHITEKTUR.md](KUBERNETES_ARCHITEKTUR.md) oder Folie:

```
Browser (HTTPS)
    ↓
traefik-gateway :443
    ↓
HTTPRoute web-check-route  (course-7.network.garden)
    ↓
Service web-check-svc :8080
    ↓
Pod web-check :3000
    ↓
Image lissy93/web-check
```

**Sagen:**
> „Jede Schicht hat eine Aufgabe: Gateway für HTTPS, HTTPRoute für die Domain, Service für stabile interne Adresse, Pod für den laufenden Container, Image als Vorlage.  
> Unser Team: **lad** Image, **lob** Deployment, **las** Service und Route, **bls** Tests und diese Demo.“

---

### 14:00–15:00 · bls — Fazit & Q&A

**Sagen:**
> „Zusammenfassung: Wir haben Web-Check containerisiert und auf Kubernetes deployt — sichtbar unter **course-7.network.garden/check**.  
> Gelernt haben wir: **Pods, Deployments, Services, HTTPRoutes** — und dass Remote-Cluster Images aus einer Registry brauchen.  
> Alles dokumentiert auf **GitHub**. Vielen Dank — Fragen?“

**Typische Fragen:**

| Frage | Antwort |
|-------|---------|
| Was ist ein Pod? | Kleinste Einheit — ein oder mehrere Container |
| Warum nicht nur Docker? | Kubernetes verwaltet viele Pods, startet sie neu, skaliert sie |
| Warum `/check`? | Die App leitet von `/` dorthin weiter — Tool startet auf `/check` |
| Wo ist der Code? | github.com/leteffe/web-check-k8s |
| Wer hat was gemacht? | lad Image, lob Deployment, las Netzwerk, bls Demo |

---

## Was ihr **zeigen** müsst (Minimum)

| # | Was | Wer |
|---|-----|-----|
| 1 | App im Browser unter `/check` | bls |
| 2 | `kubectl get pods -n lab` → Running | lob |
| 3 | `kubectl get httproute -n lab` | las |
| 4 | Eine Domain analysieren | bls |
| 5 | Architektur-Diagramm | las |
| 6 | GitHub + Team-Kürzel | bls |

---

## Was ihr **sagen** müsst (Kernbotschaften)

1. **Was** ist Web-Check? (OSINT-Tool für Websites)
2. **Wo** läuft es? (Kubernetes, Namespace `lab`, Domain course-7)
3. **Wie** kommt der Traffic? (Gateway → HTTPRoute → Service → Pod)
4. **Wer** im Team? (lad, lob, las, bls + GitHub)

---

## Häufige Fehler in der Präsentation

| Problem | Ursache | Fix |
|---------|---------|-----|
| `lab` nicht gefunden | Falscher Cluster (`kind-web-check`) | `export KUBECONFIG=.../course-7.config` |
| Seite lädt nicht | Deploy fehlt | `kubectl apply -f k8s/network-garden/` |
| Nur `/` zeigt nichts Sinnvolles | App braucht `/check` | **/check** öffnen |
| `kubectl` connection refused | KUBECONFIG fehlt | Export setzen |

---

## Nach der Präsentation

```bash
# Optional: wieder auf 1 Pod
kubectl scale deployment web-check -n lab --replicas=1
```

Cluster nicht löschen — nur eure Ressourcen bei Bedarf:
```bash
kubectl delete -f k8s/network-garden/
```

---

## Kurz-Checkliste am Rednerpult

```
[ ] KUBECONFIG = course-7.config
[ ] kubectl get pods -n lab → Running
[ ] Browser: course-7.network.garden/check
[ ] Demo-Domain: wikipedia.org
[ ] Jeder weiss seine Zeit (bls→lad→lob→las→bls→lob→las→bls)
[ ] GitHub-URL parat
```
