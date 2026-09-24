# Écrans — 04. Live Market

Parcours d'achat et de vente de produits (document 10). Deux façons de payer : **payer maintenant** (argent bloqué jusqu'à la réception) ou **payer à la remise** via Mobile Money (DM-01).

---

## E-MKT-01 — Accueil Market

```text
┌──────────────────────────────────────────┐
│ ◀  Market          [⌕ Rechercher   ]     │
├──────────────────────────────────────────┤
│ [Téléphones][Mode][Beauté][Maison] ▶     │
│                                          │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│ ▒  À la une : soldes de rentrée     ▒    │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│                                          │
│ Nouveautés près de vous         Tout ▶   │
│ ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒             │
│ Robe wax  Galaxy A14 Chaise              │
│ 15 000    75 000    12 000               │
│                                          │
│ Bonnes affaires                 Tout ▶   │
│ ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒             │
│ -30 %     -20 %     -15 %                │
│                                          │
│ Boutiques recommandées          Tout ▶   │
│ ( ▒) Grâce Mode ✓   ★4,8  (Suivre)       │
│ ( ▒) ÉlectroPlus ✓  ★4,6  (Suivre)       │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

---

## E-MKT-02 — Fiche produit

```text
┌──────────────────────────────────────────┐
│ ◀                          ↗   ♡   ⋮     │
├──────────────────────────────────────────┤
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│ ▒▒▒▒▒▒▒▒▒▒▒ PHOTOS / VIDÉO ▒▒▒▒▒▒▒▒▒▒▒   │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│              ● ○ ○ ○ ○                   │
│ iPhone 11 64 Go - très bon état          │
│ 85 000 FCFA                négociable    │
│ Moungali · publié il y a 2 h             │
│                                          │
│ État        Très bon état                │
│ Stockage    64 Go                        │
│ Couleur     Noir                         │
│ Quantité    1                            │
│                                          │
│ Remise                                   │
│ • En main propre (Moungali)  gratuit     │
│ • Livraison Brazzaville     2 000 FCFA   │
│                                          │
│ Description                              │
│ Batterie 86 %, aucune rayure, avec       │
│ chargeur. Vendu car changement...        │
│ (Lire la suite)                          │
├──────────────────────────────────────────┤
│ ( ▒) Grâce Mode ✓ Identité vérifiée      │
│      ★ 4,8 (126 avis) · 214 ventes       │
│      Répond en moins d'1 h  (Boutique)   │
├──────────────────────────────────────────┤
│ [Protégé par Live] Remboursé si vous     │
│ ne recevez pas le produit.               │
├──────────────────────────────────────────┤
│ (Écrire) (Faire une offre) [Acheter]     │
└──────────────────────────────────────────┘
```

| Élément | Comportement |
|---------|-------------|
| Photos / vidéo | Glisser horizontalement ; la vidéo est en premier si elle existe ; les images se chargent floues d'abord |
| ↗ Partager | E-FEED-04 |
| ⋮ | Signaler (E-CONF-02), Copier le lien |
| Écrire | Ouvre la conversation liée à l'annonce (E-CHAT-02) |
| Faire une offre | E-MKT-03 (seulement si « négociable ») |
| Acheter | E-MKT-04 |
| Mon annonce | Si l'utilisateur est le vendeur : les boutons deviennent `(Modifier) (Booster) [Statistiques]` |
| Plus bas dans l'écran | « Autres produits de la boutique », « Produits similaires » (F-MKT-FICHE-05) |

---

## E-MKT-03 — Faire une offre (panneau du bas)

```text
┌──────────────────────────────────────────┐
│ Faire une offre                   ✕      │
├──────────────────────────────────────────┤
│ iPhone 11 64 Go                          │
│ Prix demandé : 85 000 FCFA               │
│                                          │
│ Votre offre                              │
│ [        75 000             ] FCFA       │
│                                          │
│ Suggestions : [80 000] [78 000] [75 000] │
│                                          │
│ Le vendeur a 24 h pour répondre.         │
│ Une offre acceptée est valable 24 h.     │
├──────────────────────────────────────────┤
│ [      Envoyer l'offre           ]       │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Minimum | Une offre inférieure à 50 % du prix demandé est refusée avec un message poli |
| Échanges | 3 allers-retours maximum (offre, contre-offre, offre) (F-MKT-CMD-01) |
| Suite | L'offre apparaît sous forme de carte dans la conversation (E-CHAT-02) ; acceptée, elle donne un bouton « Payer 75 000 FCFA » |

---

## E-MKT-04 — Récapitulatif de la commande

```text
┌──────────────────────────────────────────┐
│ ◀  Votre commande                        │
├──────────────────────────────────────────┤
│ ▒▒ iPhone 11 64 Go                       │
│ ▒▒ Quantité : 1        85 000 FCFA       │
│                                          │
│ Remise                                   │
│ (•) En main propre - Moungali            │
│     Lieu à convenir avec le vendeur      │
│ ( ) Livraison à domicile  2 000 FCFA     │
│     [ Adresse ou repère...       ]       │
│                                          │
│ Paiement                                 │
│ (•) Payer maintenant                     │
│     Votre argent est bloqué par Live     │
│     jusqu'à ce que vous confirmiez       │
│     la réception.                        │
│ ( ) Payer à la remise                    │
│     Vous payez par MoMo ou Airtel        │
│     au moment où vous recevez le         │
│     produit.                             │
├──────────────────────────────────────────┤
│ Produit                85 000 FCFA       │
│ Livraison                   0 FCFA       │
│ Total à payer          85 000 FCFA       │
│ Aucun frais supplémentaire.              │
├──────────────────────────────────────────┤
│ [        Continuer               ]       │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Payer maintenant | Continuer ouvre le choix du moyen de paiement (E-PAY-01) |
| Payer à la remise | Continuer **réserve** la commande sans paiement ; masqué si le vendeur exige le paiement d'avance (R-MKT-B1) ou si l'acheteur a perdu ce droit (R-MKT-B3) |
| Total | Le prix affiché est le prix payé ; la commission Live est payée par le vendeur (R-MKT-03) |

---

## E-MKT-05 — Suivi de commande (acheteur)

```text
┌──────────────────────────────────────────┐
│ ◀  Commande LV-00482                     │
├──────────────────────────────────────────┤
│ ▒▒ iPhone 11 64 Go      85 000 FCFA      │
│    Grâce Mode ✓       (Écrire)           │
│                                          │
│  ✓ Payée - argent bloqué par Live        │
│  ✓ Acceptée par le vendeur               │
│  ● Remise prévue aujourd'hui             │
│  ○ Réception confirmée                   │
│  ○ Terminée                              │
│                                          │
│ ┌──────────────────────────────────┐     │
│ │  Votre code de remise            │     │
│ │                                  │     │
│ │         4   8   2   7            │     │
│ │                                  │     │
│ │  Donnez ce code au vendeur       │     │
│ │  UNIQUEMENT quand vous avez le   │     │
│ │  produit en main et l'avez       │     │
│ │  vérifié.                        │     │
│ └──────────────────────────────────┘     │
│                                          │
│ (J'ai reçu le produit)                   │
│ (Signaler un problème)                   │
├──────────────────────────────────────────┤
│ [Protégé par Live] 85 000 FCFA           │
│ bloqués jusqu'à votre confirmation.      │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Code | Donné oralement au vendeur, qui le saisit (E-MKT-08) ; c'est la preuve de remise |
| Confirmation automatique | 48 h après la remise déclarée, sans réclamation (F-MKT-CONF-01) ; un compte à rebours s'affiche |
| Signaler un problème | Ouvre la réclamation (E-CONF-03) |
| Après la confirmation | Proposition de laisser un avis (E-CONF-01) |
| Mode « payer à la remise » | Pas de code ; l'écran indique : « Le vendeur vous enverra une demande de paiement MoMo ou Airtel au moment de la remise. Vérifiez le produit avant de valider. » |

---

## E-MKT-06 — Page boutique

```text
┌──────────────────────────────────────────┐
│ ◀                           ↗     ⋮      │
├──────────────────────────────────────────┤
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒ BANNIÈRE ▒▒▒▒▒▒▒▒▒▒▒▒▒▒    │
│ ( ▒▒ ) Grâce Mode                        │
│        ✓ Pro vérifié · Moungali          │
│        ★ 4,8 (126) · 214 ventes Live     │
│        2 340 abonnés                     │
│ [   Suivre   ]  ( Écrire )               │
├──────────────────────────────────────────┤
│ [Produits] [Vidéos] [Avis] [Infos]       │
├──────────────────────────────────────────┤
│ [Tout][Robes][Pagnes][Sacs][Promos]      │
│ ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒             │
│ Robe wax  Pagne 6y  Sac cuir             │
│ 15 000    18 000    25 000               │
│ ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒             │
│ Ensemble  Robe      Pagne                │
│ 22 000    12 000    9 000                │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

| Onglet | Contenu |
|--------|---------|
| Produits | Catalogue filtrable par catégorie de la boutique |
| Vidéos | Publications du fil de la boutique |
| Avis | Note moyenne, répartition, avis avec photos, réponses du vendeur |
| Infos | Description, horaires, zone de livraison, date d'ouverture, lien de la boutique à partager |

---

## E-MKT-07 — Mes ventes (vendeur)

```text
┌──────────────────────────────────────────┐
│ ◀  Mes ventes                            │
├──────────────────────────────────────────┤
│ [À traiter 3] [En cours 5] [Terminées]   │
├──────────────────────────────────────────┤
│ NOUVELLE · il y a 10 min                 │
│ ▒▒ Robe wax longue ×2   30 000 FCFA      │
│    Acheteur : Merveille ★4,9             │
│    Payée - argent bloqué · Livraison     │
│    Répondre avant : 23 h 50              │
│ (Refuser)            [ Accepter ]        │
├──────────────────────────────────────────┤
│ NOUVELLE · il y a 1 h                    │
│ ▒▒ Pagne 6 yards        18 000 FCFA      │
│    Acheteur : Jordy (nouveau)            │
│    Payer à la remise · Main propre       │
│ (Refuser)            [ Accepter ]        │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Délai | 24 h pour accepter ; sinon annulation et remboursement automatiques (F-MKT-CMD-06) |
| Refus | Motif obligatoire (rupture de stock, zone non desservie, autre) ; l'acheteur est remboursé immédiatement |

---

## E-MKT-08 — Remettre la commande (vendeur)

```text
┌──────────────────────────────────────────┐
│ ◀  Commande LV-00482                     │
├──────────────────────────────────────────┤
│ ▒▒ iPhone 11 64 Go      85 000 FCFA      │
│    Acheteur : Merveille  (Écrire)        │
│    Remise : en main propre               │
│                                          │
│ Au moment de la remise :                 │
│                                          │
│ MODE PAYÉ D'AVANCE                       │
│ Demandez son code à l'acheteur.          │
│       [ _ ] [ _ ] [ _ ] [ _ ]            │
│ [     Valider la remise          ]       │
│                                          │
│ ────────── ou ──────────                 │
│                                          │
│ MODE PAYER À LA REMISE                   │
│ [  Encaisser 85 000 FCFA         ]       │
│ L'acheteur reçoit la demande MoMo ou     │
│ Airtel sur son téléphone.                │
├──────────────────────────────────────────┤
│ Vous recevrez 79 900 FCFA                │
│ (85 000 - 6 % de commission Live)        │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Affichage | Seul le bloc correspondant au mode de la commande est affiché (les deux sont montrés ici pour la maquette) |
| Code juste | Remise confirmée ; argent disponible dans « Mes gains » (E-PAY-04) |
| Code faux | 5 essais maximum, puis blocage et alerte à l'acheteur |
| Encaisser | Écran d'attente identique à E-PAY-02 côté vendeur : « En attente de la validation de l'acheteur » ; succès : « Payé ✓ Vous pouvez remettre le produit » |
| Montant net | Toujours affiché au vendeur avant la remise (transparence, F-PAY-07) |
