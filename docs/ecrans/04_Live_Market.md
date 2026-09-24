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
│ ⌂Accueil ⌕Explorer (+) ✦IA ☺Moi          │
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
│ ▒▒ iPhone 11 64 Go      85 000 FCFA      │
│                                          │
│ Remise                                   │
│ (•) En main propre · Moungali            │
│ ( ) Livraison          + 2 000 FCFA      │
│                                          │
│ Paiement                                 │
│ (•) Payer maintenant                     │
│     Argent bloqué jusqu'à réception.     │
│ ( ) Payer à la remise                    │
│     MoMo ou Airtel, produit en main.     │
│                                          │
│ ▶ Écouter l'explication                  │
├──────────────────────────────────────────┤
│ Total à payer          85 000 FCFA       │
│ Aucun frais supplémentaire.              │
├──────────────────────────────────────────┤
│ [            Continuer             ]     │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Payer maintenant | Continuer ouvre le choix du moyen de paiement (E-PAY-01) |
| Livraison | Si elle est choisie, un champ « Adresse ou repère » apparaît sous l'option |
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
│  ✓ Payée · argent bloqué par Live        │
│  ✓ Acceptée par le vendeur               │
│  ● Remise prévue aujourd'hui             │
│  ○ Réception confirmée                   │
│                                          │
│ ┌──────────────────────────────────┐     │
│ │ CONFIRMER LA REMISE              │     │
│ │        ▓▓▓▓▓▓▓▓▓▓▓▓              │     │
│ │        ▓▓▓  QR  ▓▓▓              │     │
│ │        ▓▓▓▓▓▓▓▓▓▓▓▓              │     │
│ │ Code de secours : LV-K4827       │     │
│ │ Montrez-le au vendeur quand vous │     │
│ │ avez vérifié le produit.         │     │
│ │ Ce n'est PAS votre code MoMo.    │     │
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
| QR de confirmation | Le vendeur le **scanne** avec son application (E-MKT-08) ; le code `LV-` n'est dicté qu'en secours ; c'est la preuve de remise (principe 10) |
| Confirmation automatique | 48 h après la remise déclarée, sans réclamation (F-MKT-CONF-01) ; un compte à rebours s'affiche |
| Signaler un problème | Ouvre la réclamation (E-CONF-03) |
| Après la confirmation | Proposition de laisser un avis (E-CONF-01) |
| Mode « payer à la remise » | Pas de QR de confirmation ; l'écran affiche « Vérifiez le produit, puis payez » et un bouton **[ Payer maintenant 85 000 FCFA ]** que l'acheteur peut utiliser lui-même sur place (secours si la demande du vendeur n'arrive pas, E-MKT-09) |

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
│ ⌂Accueil ⌕Explorer (+) ✦IA ☺Moi          │
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
│ ⌂Accueil ⌕Explorer (+) ✦IA ☺Moi          │
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
│                                          │
│ COMMANDE PAYÉE D'AVANCE                  │
│ [   Scanner le QR de l'acheteur    ]     │
│ (Saisir le code LV- à la place)          │
│                                          │
│ ─────────────── ou ───────────────       │
│                                          │
│ PAYER À LA REMISE                        │
│ [   Encaisser 85 000 FCFA          ]     │
│ La demande n'arrive pas ?                │
│ (Afficher mon QR de paiement)            │
├──────────────────────────────────────────┤
│ Vous recevrez 79 900 FCFA                │
│ (85 000 - 6 % de commission Live)        │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Affichage | Seul le bloc correspondant au mode de la commande est affiché (les deux sont montrés ici pour la maquette) |
| QR scanné ou code juste | Remise confirmée ; argent disponible dans « Mes gains » (E-PAY-04) |
| Code faux | 5 essais maximum, puis blocage et alerte à l'acheteur |
| QR de paiement | Secours du mode « payer à la remise » : voir E-MKT-09 |
| Encaisser | Écran d'attente identique à E-PAY-02 côté vendeur : « En attente de la validation de l'acheteur » ; succès : « Payé ✓ Vous pouvez remettre le produit » |
| Montant net | Toujours affiché au vendeur avant la remise (transparence, F-PAY-07) |

---

## E-MKT-09 — QR de paiement (secours du « payer à la remise »)

Affiché par le vendeur quand la demande MoMo ou Airtel n'arrive pas sur le téléphone de l'acheteur.

```text
┌──────────────────────────────────────────┐
│ ◀  Faire payer l'acheteur                │
├──────────────────────────────────────────┤
│ Demandez à l'acheteur de scanner ce      │
│ QR avec son application Live.            │
│                                          │
│         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                   │
│         ▓▓▓   QR   ▓▓▓                   │
│         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                   │
│                                          │
│       Commande LV-00482                  │
│       85 000 FCFA                        │
│                                          │
│ Il paiera depuis son téléphone,          │
│ avec MoMo, Airtel ou Visa.               │
├──────────────────────────────────────────┤
│ En attente du paiement...   ◐            │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Scan | L'acheteur scanne depuis l'onglet ⌕ ou sa commande ; E-PAY-01 s'ouvre, pré-rempli avec la commande |
| Sans internet chez l'acheteur | Solution à étudier avec l'agrégateur : **code marchand USSD** propre à la commande (à confirmer, D-11) |
| Sécurité | Le QR contient seulement la référence de la commande, jamais un montant modifiable ni une donnée personnelle |
