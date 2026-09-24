# Test de bout en bout du prototype

Pilote l'application web compilée dans Chromium (Playwright), au format téléphone ou ordinateur, et déroule les **6 parcours** (inscription, achat, vente, visite de logement, devis, retrait, Live IA) en vérifiant à chaque étape un texte propre au résultat attendu. Une capture est enregistrée à chaque étape.

## Utilisation

```bash
# 1. Compiler et servir le prototype
cd app
flutter build web --release --no-web-resources-cdn
python3 -m http.server 8765 --directory build/web &

# 2. Lancer le test
cd test_e2e
npm install
node parcours.js                              # téléphone 360 px
LARGEUR=320 CAPTURES=captures320 node parcours.js    # petit téléphone
LARGEUR=1280 CAPTURES=captures1280 node parcours.js  # ordinateur
```

Variables : `BASE` (adresse du prototype, par défaut `http://localhost:8765/`), `LARGEUR`, `CAPTURES` (dossier des captures), `CHROMIUM` (chemin d'un Chromium déjà installé).

Le script s'arrête au premier échec, indique l'étape en cause et enregistre `NN_ECHEC.png`. Code de sortie : 0 si les 6 parcours aboutissent, 1 sinon.
