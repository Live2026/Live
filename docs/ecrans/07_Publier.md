# Écrans — 07. Publier

Le bouton central **(+)** est le point de départ de toute création. Objectif : **publier une annonce en 30 secondes** (F-MKT-PUB-01).

---

## E-PUB-01 — Que voulez-vous publier ?

```text
┌──────────────────────────────────────────┐
│ ✕  Publier                               │
├──────────────────────────────────────────┤
│ ┌──────────────────────────────────┐     │
│ │ ▒▒  Vendre un produit            │     │
│ │     Téléphone, mode, maison...   │     │
│ └──────────────────────────────────┘     │
│ ┌──────────────────────────────────┐     │
│ │ ▒▒  Louer ou vendre un bien      │     │
│ │     Appartement, maison, local...│     │
│ └──────────────────────────────────┘     │
│ ┌──────────────────────────────────┐     │
│ │ ▒▒  Proposer un service          │     │
│ │     Artisan, beauté, événement...│     │
│ └──────────────────────────────────┘     │
│ ┌──────────────────────────────────┐     │
│ │ ▒▒  Vidéo ou photo               │     │
│ │     Partager dans le fil         │     │
│ └──────────────────────────────────┘     │
│                                          │
│ Brouillons (2)                    ▶      │
│ Envois en cours (1)               ▶      │
└──────────────────────────────────────────┘
```

| Choix | Condition | Si la condition n'est pas remplie |
|-------|-----------|------------------------------------|
| Vendre un produit | C-VENDRE (N1 : 3 annonces max) | Au-delà de 3 annonces : E-PUB-07 (vérifier son identité) |
| Louer ou vendre un bien | N2 (C-IMMO-*) | E-PUB-07 |
| Proposer un service | N2 (C-SERVICES) | E-PUB-07 |
| Vidéo ou photo | N1 | — |

---

## E-PUB-02 — Photos et vidéo

```text
┌──────────────────────────────────────────┐
│ ✕                           Suivant ▶    │
├──────────────────────────────────────────┤
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│ ▒▒▒▒▒▒▒▒▒▒▒ APPAREIL PHOTO ▒▒▒▒▒▒▒▒▒▒▒   │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│         (Photo)  (●REC 0:60)             │
├──────────────────────────────────────────┤
│ Galerie                    [Tout ▼]      │
│ [▒▒✓1][▒▒✓2][▒▒  ][▒▒  ][▒▒ 0:42]        │
│ [▒▒  ][▒▒  ][▒▒  ][▒▒  ][▒▒  ]           │
├──────────────────────────────────────────┤
│ 2 photos · 0 vidéo (max 10 + 1)          │
│ Conseil : filmez l'objet en 30 s,        │
│ de près, en pleine lumière.              │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Limites | 10 photos + 1 vidéo de 60 s maximum (D-05) ; une vidéo plus longue est proposée au découpage |
| Compression | Faite sur le téléphone après la sélection (720p max, images en WebP de moins de 300 Ko), document 20, section 6.3 |
| Guide | Conseils de prise de vue propres à chaque verticale (Immo : façade, pièces, eau, sanitaires) |

---

## E-PUB-03 — Vendre un produit (formulaire unique)

```text
┌──────────────────────────────────────────┐
│ ◀  Vendre un produit       (Brouillon)   │
├──────────────────────────────────────────┤
│ [▒▒1][▒▒2][ + ]                          │
│ Titre      [ iPhone 11 64 Go         ]   │
│ Catégorie  [▼ Téléphones (suggéré)   ]   │
│ Marque     [▼ Apple ]  Modèle [▼ 11  ]   │
│ Stockage   [▼ 64 Go ]                    │
│ État       ( )Neuf (•)Très bon ( )Bon    │
│            ( )À réparer                  │
│ Prix       [ 85 000 ] FCFA               │
│            [x] Négociable                │
│ Quantité   [ 1 ]                         │
│ Description[ Batterie 86 %, avec         │
│              chargeur...           ]     │
│ Quartier   [▼ Moungali               ]   │
│ Remise     [x] En main propre            │
│            [x] Livraison [ 2 000 ]       │
│ Paiement   [ ] Exiger le paiement        │
│                d'avance                  │
├──────────────────────────────────────────┤
│ Vous recevrez 79 900 FCFA par vente      │
│ (6 % de commission Live, 0 % pendant     │
│ votre offre de lancement)                │
├──────────────────────────────────────────┤
│ [           Publier              ]       │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Attributs | Les champs (Marque, Stockage...) dépendent de la catégorie (F-MKT-PUB-03) |
| Coordonnées | Un numéro ou un lien dans le titre ou la description est refusé avec un message (R-MKT-02) |
| Publication | Passe par la modération automatique ; la vidéo est publiée dans le fil avec « Acheter » (F-MKT-PUB-06) |
| Hors connexion | « Publier » met l'annonce en file d'envoi (E-PUB-06) |

---

## E-PUB-04 — Publier un bien (assistant en 5 étapes)

Étape **4 sur 5 : prix et conditions** (la plus importante).

```text
┌──────────────────────────────────────────┐
│ ◀  Publier un bien           4 / 5       │
├──────────────────────────────────────────┤
│ ●───●───●───●───○                        │
│ Type Lieu Détails PRIX Médias            │
│                                          │
│ Loyer mensuel     [ 90 000 ] FCFA        │
│ Mois d'avance     [ 3 ]                  │
│ Mois de caution   [ 1 ]                  │
│ Commission        (•) En mois [ 1 ]      │
│                   ( ) Montant [      ]   │
│ Frais de visite   [ 2 000 ] FCFA         │
│ Charges incluses  [ ] Eau [ ] Élec.      │
├──────────────────────────────────────────┤
│ Coût d'entrée calculé :                  │
│ 90 000 × (3 + 1) + 90 000                │
│ = 450 000 FCFA                           │
│ C'est ce que verront les chercheurs.     │
├──────────────────────────────────────────┤
│ [          Suivant               ]       │
└──────────────────────────────────────────┘
```

| Étape | Contenu |
|-------|---------|
| 1 — Type | Location, vente ou meublé court ; type de bien |
| 2 — Lieu | Ville, arrondissement, quartier, repère ; point sur la carte (facultatif, **flouté** en public) |
| 3 — Détails | Chambres, salons, salles d'eau, eau, électricité, clôture, parking, inondable (F-IMMO-PUB-03) |
| 4 — Prix | Ci-dessus ; plafond des frais de visite appliqué (R-IMMO-03) |
| 5 — Médias et lien avec le bien | 4 photos minimum, vidéo recommandée ; « Je suis : propriétaire / agence mandatée / commissionnaire avec l'accord du propriétaire » + contact privé du propriétaire (F-IMMO-PUB-08) ; créneaux de visite |

---

## E-PUB-05 — Proposer un service

```text
┌──────────────────────────────────────────┐
│ ◀  Proposer un service                   │
├──────────────────────────────────────────┤
│ Métier     [▼ Climatisation/Froid    ]   │
│ Intitulé   [ Recharge de gaz         ]   │
│ Tarif      ( ) Prix fixe  [ 15 000 ]     │
│            ( ) À partir de               │
│            (•) Sur devis                 │
│            ( ) À l'heure                 │
│ Durée      [ 1 h ]                       │
│ Où ?       [x] Chez le client            │
│            [x] À mon atelier             │
│ Zones      [ Talangaï ✕][ Ouenzé ✕]      │
│            ( + Ajouter )                 │
│ Déplacement[ 3 000 ] FCFA                │
│            [x] Déduit si travaux         │
│ Photos     [▒▒][▒▒][ + ]                 │
├──────────────────────────────────────────┤
│ [          Publier               ]       │
└──────────────────────────────────────────┘
```

---

## E-PUB-06 — Envois en cours

```text
┌──────────────────────────────────────────┐
│ ◀  Envois en cours                       │
├──────────────────────────────────────────┤
│ ▒▒ Vidéo : Robe wax longue               │
│    ██████████░░░░░░  64 %                │
│    9,2 Mo sur 14 Mo · reprise auto       │
│    (Pause)                               │
├──────────────────────────────────────────┤
│ ▒▒ Annonce : Studio Plateau              │
│    En attente du réseau                  │
│    Envoi en Wi-Fi uniquement             │
│    (Envoyer maintenant)                  │
├──────────────────────────────────────────┤
│ ▒▒ Vidéo : Clim installée                │
│    En cours de vérification              │
│    Publication dans quelques minutes     │
├──────────────────────────────────────────┤
│ Paramètre : [x] Envoyer les vidéos       │
│ en Wi-Fi uniquement                      │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Reprise | Un envoi interrompu reprend là où il s'était arrêté (protocole tus) |
| Fermeture de l'application | Les envois continuent en arrière-plan quand le système le permet, sinon reprennent à la réouverture |
| Refus de modération | Notification + motif + bouton « Modifier » |

---

## E-PUB-07 — Vérification requise

Affiché quand une capacité manque.

```text
┌──────────────────────────────────────────┐
│ ✕                                        │
├──────────────────────────────────────────┤
│     Une étape avant de publier           │
│                                          │
│ Pour louer un bien, proposer un          │
│ service ou retirer vos gains, Live       │
│ doit vérifier votre identité.            │
│                                          │
│ C'est ce qui rassure les acheteurs :     │
│ les annonces vérifiées reçoivent         │
│ plus de contacts.                        │
│                                          │
│ Il vous faut :                           │
│ ✓ Votre CNI ou passeport                 │
│ ✓ Un selfie                              │
│ ✓ Un numéro MoMo ou Airtel à             │
│   votre nom                              │
│                                          │
│ Durée : 3 minutes. Réponse en            │
│ moins de 24 h.                           │
├──────────────────────────────────────────┤
│ [    Vérifier mon identité       ]       │
│ ( Plus tard )                            │
└──────────────────────────────────────────┘
```

Suite : E-MOI-03 (vérification d'identité).
