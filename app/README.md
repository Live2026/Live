# Live — prototype cliquable (Flutter)

Prototype des parcours clés de Live, destiné au **test terrain** avec de vrais utilisateurs avant la construction complète. **Aucune transaction réelle, aucun appel réseau** : les données sont fictives (`lib/data/mock.dart`) et les paiements, scans de QR et générations IA sont simulés.

## Parcours couverts

1. Inscription (téléphone, code SMS, profil, code secret)
2. Acheter un produit (payer maintenant ou à la remise, QR de confirmation)
3. Vendre (publier, accepter, remettre en scannant le QR, gains)
4. Visiter un logement (coût d'entrée, créneau, frais de visite, QR de visite)
5. Demander un devis (devis comparés, acompte, QR de démarrage)
6. Retirer ses gains
7. Live IA (achat de crédits, CV, exercice en mode apprentissage, documents)

Les scénarios du test terrain sont dans l'application : **Moi → Scénarios de test** (voir `docs/prototype/Protocole_test_terrain.md`).

## Lancer

```bash
flutter pub get
flutter run -d chrome                 # navigateur
flutter build web --release --no-web-resources-cdn   # version web autonome
flutter build apk --release           # Android (nécessite le SDK Android)
```

`--no-web-resources-cdn` embarque le moteur de rendu : l'application ne télécharge rien depuis un CDN. Les polices (Roboto) sont également embarquées (`assets/fonts/`, licence OFL).

## Vérifier

```bash
flutter analyze
flutter test                          # logique (paiements, crédits, ventes) + navigation adaptative
```

Test de bout en bout des 6 parcours dans un vrai navigateur : voir `test_e2e/README.md`.

## Organisation

| Dossier | Contenu |
|---------|---------|
| `lib/core/` | Thème (palette officielle, arrondis de 8 px), navigation adaptative, formats (FCFA, notes), mise en page adaptative |
| `lib/data/` | Données fictives et état de l'application (Riverpod) |
| `lib/shared/` | Composants communs (QR de confirmation, bandeau de protection, frise, clavier de code) et animations |
| `lib/features/` | Un dossier par parcours : `auth`, `feed`, `explore`, `market`, `immo`, `services`, `pay`, `ia`, `messages`, `me`, `publish`, `test` |

Conception : `docs/` (cahier des charges, maquettes dans `docs/ecrans/`, architecture dans `docs/20_Architecture_technique.md`).
