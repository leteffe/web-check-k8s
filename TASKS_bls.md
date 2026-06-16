# Aufgaben: bls — Tests, Troubleshooting & Präsentation

> Übersicht für das ganze Team: [KUBERNETES_PROJEKTPLAN.md](KUBERNETES_PROJEKTPLAN.md)

**Rolle:** End-to-End testen, Fehler dokumentieren, Demo und Präsentation leiten.  
**Du brauchst von allen:** Image (lad), Deployment/Pods (lob), Zugriff-URL (las).  
**Geschätzte Zeit:** 1–2 Stunden Vorbereitung + 10–15 Min Präsentation

---

## Voraussetzungen

- [ ] lad, lob und las haben ihre Lieferobjekte erledigt
- [ ] Zugriffs-URL von las (NodePort oder Port-Forward)
- [ ] Terminal mit `kubectl` und Browser bereit

---

## Task 1: Vollständiges Deployment testen

**Ziel:** Gesamtes Setup funktioniert von Null bis Browser.

```bash
# Optional: sauberer Start
kubectl delete -f k8s/ --ignore-not-found
kubectl apply -f k8s/

kubectl get all -l app=web-check
kubectl wait --for=condition=available deployment/web-check --timeout=120s
```

- [ ] Deployment: `AVAILABLE`
- [ ] Pods: alle `Running`
- [ ] Service: Port/NodePort sichtbar
- [ ] Browser: App erreichbar (URL von las)

**Abnahme:** Checkliste unten vollständig abhakbar.

---

## Task 2: Smoke-Test der App

**Ziel:** Web-Check erfüllt seine Kernfunktion im Cluster.

- [ ] Startseite lädt ohne Fehler
- [ ] Domain eingeben (z. B. `wikipedia.org` oder `example.com`)
- [ ] Analyse startet und Ergebnisse erscheinen
- [ ] Kein sofortiger 500-Fehler in der UI

Bei Fehlern:

```bash
kubectl logs -l app=web-check --tail=100
kubectl describe pod -l app=web-check
```

- [ ] Ergebnis kurz notieren (1–3 Sätze) für Testprotokoll

**Abnahme:** Mindestens eine erfolgreiche Domain-Analyse im Browser.

---

## Task 3: kubectl-Checks durchführen

**Ziel:** Du kannst Cluster-Status live in der Demo zeigen.

```bash
kubectl get deployments,pods,services -l app=web-check
kubectl describe deployment web-check
kubectl logs -l app=web-check --tail=20
kubectl get endpoints web-check
```

- [ ] Alle Befehle einmal ausgeführt und Output verstanden
- [ ] Screenshots der wichtigsten Outputs (Backup für Präsentation)

**Abnahme:** Du erklärst jeden Befehl in einem Satz.

---

## Task 4: Troubleshooting-Sheet erstellen

**Ziel:** Team und Lehrperson sehen, dass ihr Fehler systematisch lösen könnt.

Erstelle [`k8s/TROUBLESHOOTING.md`](k8s/TROUBLESHOOTING.md) (oder Abschnitt in README):

| Fehler | Bedeutung | Wer | Lösung |
|--------|-----------|-----|--------|
| `ImagePullBackOff` | Image nicht im Cluster | lad | `eval $(minikube docker-env)` + neu bauen |
| `CrashLoopBackOff` | Container startet nicht | lob/lad | `kubectl logs`, Speicher-Limits |
| `Pending` | Kein Platz auf Node | lob | Cluster-Ressourcen / replicas reduzieren |
| Leere Endpoints | Service findet keine Pods | las/lob | Label `app: web-check` prüfen |
| Browser: Verbindung fehlgeschlagen | Falscher Port/Forward | las | URL und Port-Forward prüfen |
| Seite lädt ewig | Pod nicht Ready | lob | Logs, Chromium braucht Zeit |

- [ ] Mindestens 4 Zeilen ausgefüllt
- [ ] Einen Fehler bewusst nachstellen (optional) und Lösung dokumentieren

**Abnahme:** Datei im Repo, Team hat Link.

---

## Task 5: Demo-Skript schreiben

**Ziel:** 10–15 Minuten Ablauf ohne Improvisation.

Erstelle [`DEMO_SKRIPT.md`](DEMO_SKRIPT.md) mit Zeiten und Sprechern:

```markdown
# Demo-Skript (10–15 Min)

## Vor der Präsentation
- [ ] Cluster läuft, `kubectl get pods` → Running
- [ ] Port-Forward gestartet ODER NodePort-URL notiert
- [ ] Browser-Tab mit App vorbereitet
- [ ] Zweites Terminal für kubectl offen

## Ablauf
| Zeit | Wer | Aktion |
|------|-----|--------|
| 0:00 | bls | Begrüssung, Ziel |
| 1:30 | lad | Docker / Image |
| 3:00 | lob | kubectl get pods |
| 5:00 | las | Service, Browser |
| 7:00 | bls | Domain analysieren |
| 10:00 | lob | Skalierung |
| 12:00 | las | Architektur |
| 14:00 | bls | Fazit, Q&A |
```

- [ ] Skript mit Team abgestimmt
- [ ] Generalprobe (1x komplett durchspielen)

**Abnahme:** Generalprobe erfolgreich oder Backup (Screenshots/Video) bereit.

---

## Task 6: Präsentationsfolien vorbereiten

**Ziel:** 5–8 Folien, jede Person hat sichtbaren Beitrag.

**Vorschlag Folien:**

1. Titelfolie — Team, Projektname, Web-Check auf Kubernetes
2. Was ist Web-Check? — OSINT, Port 3000, Docker
3. Kubernetes-Architektur — Diagramm aus Hauptplan
4. Deployment & Pods — lob
5. Service & Zugriff — las
6. Live-Demo — Screenshot als Fallback
7. Lessons Learned — was war schwierig?
8. Q&A

- [ ] Folien erstellt (Google Slides, PowerPoint, etc.)
- [ ] Jeder hat mindestens eine Folie oder einen Live-Block

---

## Task 7: Backup-Plan für Live-Demo

**Ziel:** Präsentation scheitert nicht an Technik.

- [ ] Screenshots: `kubectl get pods`, Browser mit App, Analyse-Ergebnis
- [ ] Optional: 30-Sekunden-Screenrecording
- [ ] Port-Forward-Befehl auf Folie/notiert — vor Demo neu starten
- [ ] Wenn Live-Demo hängt: auf Screenshots wechseln, weiter erklären

**Abnahme:** Backup auf USB/Cloud — ohne Internet abspielbar.

---

## Lieferobjekte (Checkliste)

- [ ] End-to-End-Test bestanden
- [ ] Kurzes Testprotokoll (Datum, URL, getestete Domain, Ergebnis)
- [ ] [`k8s/TROUBLESHOOTING.md`](k8s/TROUBLESHOOTING.md) oder README-Abschnitt
- [ ] [`DEMO_SKRIPT.md`](DEMO_SKRIPT.md)
- [ ] Präsentationsfolien
- [ ] Backup-Screenshots/Video

---

## Präsentation (dein Teil, ca. 5 Min gesamt)

### Block 1 — 0:00–1:30

- Team vorstellen
- Projektziel: Web-Check containerisiert auf Kubernetes
- Ablauf der Demo ankündigen

### Block 2 — 7:00–10:00 (moderierst du)

1. Browser: App öffnen (URL von las)
2. Domain eingeben, Analyse zeigen
3. Parallel oder danach: `kubectl logs -l app=web-check --tail=10`
4. Optional: Pod löschen lassen (lob) — neuer Pod erscheint

### Block 3 — 14:00–15:00

- Fazit: Was haben wir gelernt?
- Kubernetes-Vorteile: Skalierung, Selbstheilung, reproduzierbare Deployments
- Q&A moderieren

**Satz zum Merken:** „Wir haben die gleiche App, die lokal in Docker lief, jetzt hochverfügbar mit mehreren Pods auf Kubernetes betrieben.“

---

## Live-Demo Checkliste (am Präsentationstag)

Kopiere und am Tag abhaken:

```
[ ] minikube/cluster gestartet
[ ] kubectl get pods → 2/2 Running
[ ] Zugriff getestet (Browser lädt)
[ ] Port-Forward läuft (falls nötig) — Terminal nicht schliessen
[ ] Demo-Domain notiert: _______________
[ ] Screenshots als Backup griffbereit
[ ] Team weiss Sprecher-Reihenfolge
```

---

## Hilfe bei Problemen

| Situation | Aktion |
|-----------|--------|
| Pod nicht Ready vor Demo | lob skalieren/restart; 5 Min Puffer einplanen |
| Internet in Schule blockiert | Domain-Analyse evtl. eingeschränkt — Screenshot zeigen |
| kubectl funktioniert nicht | Docker Desktop / minikube neu starten |
| Teammitglied fehlt | bls übernimmt kurz deren Block mit deren Folie |

**Ansprechpartner:** lad (Image), lob (Pods), las (URL/Service)
