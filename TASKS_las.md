# Aufgaben: las — Service & Zugriff

> Übersicht für das ganze Team: [KUBERNETES_PROJEKTPLAN.md](KUBERNETES_PROJEKTPLAN.md)

**Rolle:** Netzwerk-Zugriff auf Web-Check im Cluster — Service, Ports, optional Ingress.  
**Du brauchst von lob:** laufende Pods mit Label `app: web-check`.  
**Du lieferst an bls:** stabile URL/Befehle für Browser-Zugriff.  
**Geschätzte Zeit:** 1–2 Stunden

---

## Voraussetzungen

- [ ] `kubectl` und Cluster laufen
- [ ] lob hat Deployment angewendet — Pods sind `Running`
- [ ] Label abgestimmt: `app: web-check`

Prüfen:

```bash
kubectl get pods -l app=web-check
```

---

## Task 1: Service-Manifest anlegen

**Ziel:** Datei [`k8s/service.yaml`](k8s/service.yaml) leitet Traffic zu den Pods.

- [ ] Datei `k8s/service.yaml` erstellen
- [ ] `kind: Service`, Name: `web-check`
- [ ] Selector: `app: web-check` (muss zu lob's Deployment passen)
- [ ] `port: 80` → `targetPort: 3000` (Container-Port aus Dockerfile)
- [ ] Typ: `NodePort` (einfach für Demo) oder `ClusterIP` (mit Port-Forward)

**Variante A — NodePort (empfohlen für Schul-Demo):**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-check
  labels:
    app: web-check
spec:
  type: NodePort
  selector:
    app: web-check
  ports:
    - name: http
      port: 80
      targetPort: 3000
      nodePort: 30080
```

**Variante B — ClusterIP + Port-Forward:**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-check
spec:
  type: ClusterIP
  selector:
    app: web-check
  ports:
    - port: 80
      targetPort: 3000
```

- [ ] Gewählte Variante im Team kommunizieren

**Abnahme:** `kubectl apply --dry-run=client -f k8s/service.yaml` ohne Fehler.

---

## Task 2: Service deployen und Endpoints prüfen

**Ziel:** Service ist mit Pods verbunden.

```bash
kubectl apply -f k8s/service.yaml
kubectl get svc web-check
kubectl get endpoints web-check
kubectl describe svc web-check
```

- [ ] Service existiert
- [ ] `ENDPOINTS` zeigt IP-Adressen (nicht `<none>`)
- [ ] Bei leeren Endpoints: mit lob Labels prüfen (`app: web-check`)

**Abnahme:** `kubectl get endpoints web-check` listet mindestens eine Pod-IP.

---

## Task 3: Zugriff im Browser testen

**Ziel:** Web-Check ist von deinem Rechner aus erreichbar.

### Bei NodePort

```bash
# minikube
minikube service web-check --url

# oder manuell
kubectl get svc web-check
# NodePort z. B. 30080 → http://localhost:30080 (minikube) oder Node-IP:30080
```

### Bei ClusterIP + Port-Forward

```bash
kubectl port-forward svc/web-check 8080:80
# Browser: http://localhost:8080
```

- [ ] Startseite lädt
- [ ] Keine Verbindungsfehler / Timeout
- [ ] Optional: kurze Domain-Analyse testen

**Abnahme:** URL und Befehl an bls weitergeben (für Demo-Skript).

---

## Task 4: Zugriff dokumentieren

**Ziel:** Jeder im Team kann die App öffnen.

Ergänze [`k8s/README.md`](k8s/README.md) mit Abschnitt **„Zugriff (las)“**:

```markdown
## Zugriff (las)

# Service anwenden
kubectl apply -f k8s/service.yaml

# Option NodePort (minikube)
minikube service web-check --url

# Option Port-Forward
kubectl port-forward svc/web-check 8080:80
# → http://localhost:8080
```

- [ ] Konkrete URL für eure Umgebung eingetragen
- [ ] Hinweis: Service-Port **80** → Container-Port **3000**

**Abnahme:** bls kann ohne Nachfragen die App im Browser öffnen.

---

## Task 5: Optional — Ingress einrichten

**Nur wenn Zeit und Ingress-Controller vorhanden.**

```bash
# minikube
minikube addons enable ingress
```

Erstelle [`k8s/ingress.yaml`](k8s/ingress.yaml):

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-check
spec:
  rules:
    - host: web-check.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web-check
                port:
                  number: 80
```

```bash
# /etc/hosts: 127.0.0.1 web-check.local (minikube IP ggf. anpassen)
kubectl apply -f k8s/ingress.yaml
```

- [ ] Ingress nur wenn Demo stabil — sonst bei NodePort/Port-Forward bleiben

**Abnahme:** Bonus-Punkt in Präsentation, nicht Pflicht.

---

## Task 6: Netzwerk-Fehlerbilder kennen

**Ziel:** Du kannst typische Service-Probleme erklären.

| Symptom | Ursache | Prüfbefehl |
|---------|---------|------------|
| Connection refused | Falscher targetPort | `targetPort: 3000`? |
| Keine Endpoints | Label-Mismatch | `kubectl get pods --show-labels` |
| 404 / leere Seite | App im Pod nicht ready | `kubectl logs -l app=web-check` |
| Port belegt (Forward) | Anderer Prozess auf 8080 | anderen Port wählen: `8081:80` |

- [ ] Mindestens einen Befehl aus der Tabelle selbst ausprobiert

---

## Lieferobjekte (Checkliste)

- [ ] [`k8s/service.yaml`](k8s/service.yaml) im Repo
- [ ] App im Browser erreichbar (URL dokumentiert)
- [ ] Zugriffs-Anleitung in `k8s/README.md`
- [ ] Optional: `k8s/ingress.yaml`

---

## Präsentation (dein Teil, ca. 4 Min gesamt)

### Block 1 — 5:00–7:00 (ca. 2 Min)

1. **Warum Service?** — Pods haben wechselnde IPs; Service ist stabile Anlaufstelle
2. Erklären: Port **80** (Service) → **3000** (Container)
3. Live: `kubectl get svc web-check`
4. Browser öffnen — App zeigen

### Block 2 — 12:00–14:00 (ca. 2 Min)

1. Architektur-Folie aus [KUBERNETES_PROJEKTPLAN.md](KUBERNETES_PROJEKTPLAN.md) zeigen
2. Datenfluss: Browser → Service → Pod(s) → Image
3. Kurz NodePort vs. Port-Forward erwähnen

**Satz zum Merken:** „Der Service leitet Anfragen an alle Pods mit Label `app: web-check` weiter — load balancing inklusive.“

---

## Hilfe bei Problemen

| Problem | Mögliche Lösung |
|---------|-----------------|
| Endpoints leer | lob: Pods und Labels prüfen |
| 502 / Bad Gateway | Pods nicht Ready — `kubectl get pods` |
| NodePort nicht erreichbar | minikube IP / `minikube service` nutzen |
| Port-Forward bricht ab | Terminal offen lassen während Demo |

**Ansprechpartner:** lob (Pods), lad (Image/App), bls (Demo-Ablauf)
