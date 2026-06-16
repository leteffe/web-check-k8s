# Aufgaben: lob — Deployment & Pods

> Übersicht für das ganze Team: [KUBERNETES_PROJEKTPLAN.md](KUBERNETES_PROJEKTPLAN.md)

**Rolle:** Kubernetes-Deployment erstellen, Pods betreiben und skalieren.  
**Du brauchst von lad:** Image `web-check:local` im Cluster verfügbar.  
**Du lieferst an las:** laufende Pods mit Label `app: web-check`.  
**Geschätzte Zeit:** 2 Stunden

---

## Voraussetzungen

- [ ] `kubectl` funktioniert (`kubectl cluster-info`)
- [ ] Cluster läuft (minikube/kind/Docker Desktop)
- [ ] lad hat Image `web-check:local` bereitgestellt und gemeldet
- [ ] Ordner `k8s/` im Repo anlegen (falls noch nicht vorhanden)

```bash
mkdir -p k8s
```

---

## Task 1: Deployment-Manifest anlegen

**Ziel:** Datei [`k8s/deployment.yaml`](k8s/deployment.yaml) existiert und ist valide.

- [ ] Datei `k8s/deployment.yaml` erstellen
- [ ] `apiVersion: apps/v1`, `kind: Deployment`
- [ ] Name: `web-check`
- [ ] Labels: `app: web-check` (metadata + pod template)
- [ ] `replicas: 2`
- [ ] Container-Image: `web-check:local`
- [ ] `imagePullPolicy: IfNotPresent`
- [ ] `containerPort: 3000`

**Startvorlage:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-check
  labels:
    app: web-check
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-check
  template:
    metadata:
      labels:
        app: web-check
    spec:
      containers:
        - name: web-check
          image: web-check:local
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 3000
```

**Abnahme:** `kubectl apply --dry-run=client -f k8s/deployment.yaml` ohne Fehler.

---

## Task 2: Deployment anwenden

**Ziel:** Pods werden erstellt und laufen.

```bash
kubectl apply -f k8s/deployment.yaml
kubectl get deployments
kubectl get pods -l app=web-check
kubectl describe deployment web-check
```

- [ ] Deployment Status: `Available`
- [ ] Beide Pods Status: `Running` (kann 1–2 Min dauern)
- [ ] Bei `ImagePullBackOff`: lad kontaktieren (Task 4 bei lad)
- [ ] Bei `CrashLoopBackOff`: Logs prüfen — `kubectl logs -l app=web-check`

**Abnahme:** `kubectl get pods -l app=web-check` zeigt 2/2 `Running`.

---

## Task 3: Ressourcen-Limits setzen (optional, empfohlen)

**Ziel:** Cluster wird nicht von Chromium-Pods überlastet.

In `k8s/deployment.yaml` unter dem Container ergänzen:

```yaml
          resources:
            requests:
              memory: "512Mi"
              cpu: "250m"
            limits:
              memory: "1Gi"
              cpu: "500m"
```

- [ ] Limits eingetragen
- [ ] `kubectl apply -f k8s/deployment.yaml`
- [ ] Pods starten neu und werden wieder `Running`

**Abnahme:** `kubectl describe pod <name>` zeigt Requests/Limits.

---

## Task 4: Pods inspizieren und dokumentieren

**Ziel:** Du verstehst den Pod-Lebenszyklus und kannst ihn erklären.

```bash
kubectl get pods -l app=web-check -o wide
kubectl describe pod <pod-name>
kubectl logs <pod-name> --tail=30
```

- [ ] Pod-Name, Node und IP notieren
- [ ] In eigenen Worten: Was macht das Deployment vs. ein einzelner Pod?
- [ ] Kurz in `k8s/README.md` Abschnitt **„Deployment (lob)“** ergänzen:

```markdown
## Deployment (lob)

kubectl apply -f k8s/deployment.yaml
kubectl get pods -l app=web-check
kubectl logs -l app=web-check --tail=50
```

**Abnahme:** las kann die Pod-Labels `app: web-check` für den Service nutzen.

---

## Task 5: Skalierung vorbereiten (Demo)

**Ziel:** In der Präsentation Replicas live ändern können.

```bash
# Hochskalieren
kubectl scale deployment web-check --replicas=3
kubectl get pods -l app=web-check -w

# Für Demo wieder auf 2
kubectl scale deployment web-check --replicas=2
```

- [ ] Skalierung auf 3 getestet — 3 Pods `Running`
- [ ] Zurück auf 2 skaliert
- [ ] Optional: einen Pod löschen und beobachten, dass Kubernetes einen neuen startet:

```bash
kubectl delete pod <ein-pod-name>
kubectl get pods -l app=web-check -w
```

**Abnahme:** Du kannst live zeigen: „Mehr Replicas = mehr Pods.“

---

## Task 6: Integration mit las abstimmen

**Ziel:** Service findet die Pods.

- [ ] Label `app: web-check` mit las abgestimmt (muss im Service-Selector identisch sein)
- [ ] las hat Zugriff getestet — App im Browser erreichbar
- [ ] Bei Problemen gemeinsam: `kubectl get endpoints web-check`

**Abnahme:** bls kann End-to-End-Test durchführen.

---

## Lieferobjekte (Checkliste)

- [ ] [`k8s/deployment.yaml`](k8s/deployment.yaml) im Repo
- [ ] 2 laufende Pods mit Label `app: web-check`
- [ ] Skalierungs-Demo geprobt
- [ ] Deployment-Befehle in `k8s/README.md`

---

## Präsentation (dein Teil, ca. 4 Min gesamt)

### Block 1 — 3:00–5:00 (ca. 2 Min)

1. Was ist ein **Deployment**? — verwaltet gewünschte Anzahl Pods
2. Was ist ein **Pod**? — läuft unser Container mit Web-Check
3. Live: `kubectl get pods -l app=web-check`
4. Kurz: `kubectl describe deployment web-check`

### Block 2 — 10:00–12:00 (ca. 2 Min)

1. `kubectl scale deployment web-check --replicas=3`
2. `kubectl get pods` — neuer Pod erscheint
3. Erklären: Kubernetes hält die gewünschte Anzahl automatisch

**Satz zum Merken:** „Das Deployment sagt Kubernetes: Ich will 2 Kopien der App — wenn einer abstürzt, startet ein neuer.“

---

## Hilfe bei Problemen

| Problem | Mögliche Lösung |
|---------|-----------------|
| ImagePullBackOff | lad: Image im Cluster-Daemon bauen |
| CrashLoopBackOff | `kubectl logs`; oft Speicher — Limits erhöhen |
| Pods Pending | `kubectl describe pod` — zu wenig RAM im Cluster |
| 0/2 Ready | Warten; Container braucht Zeit (Chromium) |

**Ansprechpartner:** lad (Image), las (Service/Ports), bls (Gesamttest)
