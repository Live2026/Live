# Écrans — 05. Live Immo

Parcours logement et agences (document 11). Promesse : **« Visite payée = visite garantie. Réservation payée = argent protégé. »**

---

## E-IMMO-01 — Accueil Immo

```text
┌──────────────────────────────────────────┐
│ ◀  Immo            [⌕ Quartier, type ]   │
├──────────────────────────────────────────┤
│ [•Louer] [ Acheter ] [ Meublé court ]    │
│                                          │
│ Que cherchez-vous ?                      │
│ [Studio][Appart.][Maison][Chambre]       │
│ [Local commercial][Bureau][Parcelle]     │
│                                          │
│ Mes alertes logement             ▶       │
│ 2 ch. Moungali < 100 000 · 3 nouv.       │
│                                          │
│ Nouveaux logements vérifiés     Tout ▶   │
│ ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒             │
│ 2 ch.     Studio    3 ch.                │
│ Moungali  Bacongo   Plateau              │
│ 90 000    45 000    150 000              │
│                                          │
│ Agences vérifiées               Tout ▶   │
│ ( ▒) Agence Les Palmiers ✓ ★4,7          │
│ ( ▒) Immo Plus ✓           ★4,5          │
│                                          │
│ (Je cherche : publier ma demande)        │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

| Élément | Comportement |
|---------|-------------|
| « Je cherche » | Demande inversée : le chercheur décrit son besoin et les annonceurs vérifiés proposent leurs biens (F-IMMO-RECH-07, S) |

---

## E-IMMO-02 — Résultats logement

```text
┌──────────────────────────────────────────┐
│ ◀  Location · Moungali, Plateau          │
├──────────────────────────────────────────┤
│ [Filtres (4)] [Trier ▼] [Carte]          │
│ 42 logements       (Créer une alerte)    │
├──────────────────────────────────────────┤
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ ▶ Vidéo réelle  │
│ Appartement 2 ch. · Moungali             │
│ 90 000 FCFA / mois                       │
│ Entrée : 450 000 FCFA (3+1 mois+com.)    │
│ Forage · Compteur · Parking              │
│ ✓ Agence Les Palmiers ★4,7 · 5 j         │
├──────────────────────────────────────────┤
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│ Studio · Plateau                         │
│ 45 000 FCFA / mois                       │
│ Entrée : 180 000 FCFA                    │
│ Réseau SNDE · Compteur prépayé           │
│ ✓ Particulier vérifié ★4,9 · 2 j         │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

| Élément | Détail |
|---------|--------|
| « Entrée » | **Coût total d'entrée** calculé automatiquement (avance + caution + commission) (F-IMMO-PUB-04) |
| « 5 j » | Disponibilité confirmée il y a 5 jours (F-IMMO-FICHE-03) |
| Carte | Points **floutés** (environ 200 m) (DI-03) |

---

## E-IMMO-03 — Fiche logement

```text
┌──────────────────────────────────────────┐
│ ◀                          ↗   ♡   ⋮     │
├──────────────────────────────────────────┤
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│ ▒▒▒▒▒▒▒▒▒▒ VIDÉO DE VISITE ▒▒▒▒▒▒▒▒▒▒▒   │
│ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒   │
│             ● ○ ○ ○ ○ ○                  │
│ Appartement 2 chambres · Moungali        │
│ Disponibilité confirmée il y a 5 j       │
├──────────────────────────────────────────┤
│ Loyer                  90 000 / mois     │
│ Avance (3 mois)          270 000         │
│ Caution (1 mois)          90 000         │
│ Commission                90 000         │
│ COÛT D'ENTRÉE TOTAL    450 000 FCFA      │
│ Frais de visite            2 000 FCFA    │
├──────────────────────────────────────────┤
│ 2 chambres · 1 salon · 1 douche int.     │
│ Eau : forage · Élec. : compteur indiv.   │
│ Clôturé · Gardien · Parking · Goudron    │
│ Zone inondable : non                     │
│ Repère : derrière le marché Total        │
│ Adresse exacte après réservation         │
│ de la visite.                            │
├──────────────────────────────────────────┤
│ ( ▒) Agence Les Palmiers                 │
│      ✓ Agence vérifiée (visitée)         │
│      ★ 4,7 · 38 logements loués via Live │
├──────────────────────────────────────────┤
│ [Protégé par Live] Ne payez jamais de    │
│ frais ou d'avance hors de Live.          │
├──────────────────────────────────────────┤
│ (Écrire)        [ Demander une visite ]  │
└──────────────────────────────────────────┘
```

| Élément | Comportement |
|---------|-------------|
| Coût d'entrée | Mis en évidence ; c'est l'information la plus attendue |
| Adresse et numéro | Masqués jusqu'au paiement de la visite (R-IMMO-02) |
| ⋮ Signaler | Motifs : Déjà loué, Faux bien, Prix différent, Paiement hors Live demandé, Photos volées (F-IMMO-CONF-04) |
| Parcelle à vendre | Avertissement permanent : « Live ne garantit pas la situation foncière. Vérifiez le titre chez un notaire avant tout paiement. » (R-IMMO-10) |

---

## E-IMMO-04 — Choisir un créneau et payer la visite

```text
┌──────────────────────────────────────────┐
│ ◀  Demander une visite                   │
├──────────────────────────────────────────┤
│ Appartement 2 ch. · Moungali             │
│                                          │
│ Choisissez un créneau                    │
│ [Lun 29] [•Mar 30] [Mer 1] [Jeu 2]       │
│                                          │
│ ( ) 09:00   (•) 10:30   ( ) 14:00        │
│ ( ) 15:30   ( ) 17:00                    │
│                                          │
│ Vous visitez aussi d'autres biens de     │
│ cette agence le même jour ?              │
│ ( + Ajouter un bien : 1 seul frais )     │
├──────────────────────────────────────────┤
│ Frais de visite          2 000 FCFA      │
│                                          │
│  Si l'annonceur ne vient pas ou si le    │
│  bien n'est pas disponible : vous        │
│  êtes remboursé.                         │
│  Si vous ne venez pas : les frais        │
│  sont versés à l'annonceur.              │
├──────────────────────────────────────────┤
│ [    Payer 2 000 FCFA            ]       │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Paiement | Ouvre E-PAY-01 ; les frais sont **bloqués** jusqu'à la visite (F-IMMO-VIS-02) |
| Visite gratuite | Si les frais sont nuls : bouton « Réserver la visite » sans paiement |
| Conditions | Rappel clair des règles d'absence (D-25, F-IMMO-VIS-06) |

---

## E-IMMO-05 — Ma visite (chercheur)

```text
┌──────────────────────────────────────────┐
│ ◀  Visite · Mar 30 sept. · 10:30         │
├──────────────────────────────────────────┤
│ Appartement 2 ch. · Moungali             │
│ Statut : ✓ Confirmée                     │
│                                          │
│ Adresse exacte                           │
│ 12, rue Mbochis, Moungali                │
│ Repère : derrière le marché Total        │
│ (Itinéraire)                             │
│                                          │
│ Votre contact                            │
│ Christian · Agence Les Palmiers          │
│ 06 555 44 33   (Appeler) (Écrire)        │
│                                          │
│ ┌──────────────────────────────────┐     │
│ │   Votre code de visite           │     │
│ │                                  │     │
│ │          3   9   1   5           │     │
│ │                                  │     │
│ │   Donnez-le à l'agent une fois   │     │
│ │   sur place.                     │     │
│ └──────────────────────────────────┘     │
│                                          │
│ (Le bien ne correspond pas)              │
│ (Annuler la visite)                      │
├──────────────────────────────────────────┤
│ Rappel envoyé la veille et 2 h avant.    │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Informations révélées | Adresse exacte et numéro : seulement après le paiement (F-IMMO-VIS-03) |
| « Le bien ne correspond pas » | Disponible jusqu'à 2 h après le créneau, avec photos ; les frais restent bloqués et un litige est ouvert (F-IMMO-VIS-07) |
| Annuler | Gratuit jusqu'à 12 h avant ; au-delà, les frais sont versés à l'annonceur |

---

## E-IMMO-06 — Offre de réservation (chercheur)

Reçue dans la conversation après la visite.

```text
┌──────────────────────────────────────────┐
│ ◀  Offre de réservation                  │
├──────────────────────────────────────────┤
│ Appartement 2 ch. · Moungali             │
│ Proposée par Agence Les Palmiers ✓       │
│                                          │
│ Acompte de réservation   90 000 FCFA     │
│ À signer avant le       5 octobre        │
│ Le bien est retiré des recherches        │
│ dès votre paiement.                      │
│                                          │
│ Conditions d'annulation                  │
│ • Par l'agence : remboursement total     │
│ • Par vous avant le 2 oct. : total       │
│ • Par vous après : 50 % remboursés       │
├──────────────────────────────────────────┤
│ [Protégé par Live] L'acompte est         │
│ versé à l'agence seulement quand         │
│ vous confirmez tous les deux la          │
│ signature du bail.                       │
├──────────────────────────────────────────┤
│ (Refuser)     [ Payer 90 000 FCFA ]      │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| Suite | Paiement (E-PAY-01), puis statut « Réservé » ; après la signature, les deux parties appuient sur « Bail signé » ; l'acompte est versé moins 2 % à la charge de l'agence (F-IMMO-RES-03) |

---

## E-IMMO-07 — Tableau de bord agence

```text
┌──────────────────────────────────────────┐
│ ◀  Agence Les Palmiers ✓      [Pro]      │
├──────────────────────────────────────────┤
│ Aujourd'hui                              │
│  Visites prévues        6                │
│  Demandes nouvelles     4                │
│  Réservations en cours  2                │
│  Gains ce mois    184 000 FCFA           │
├──────────────────────────────────────────┤
│ [Visites] [Demandes] [Biens] [Équipe]    │
├──────────────────────────────────────────┤
│ 10:30  2 ch. Moungali                    │
│        Merveille ★4,9 · payé             │
│        Agent : Christian                 │
│        [ Saisir le code ]                │
│ 14:00  Studio Plateau                    │
│        Jordy · payé                      │
│        Agent : Nadège                    │
│        [ Saisir le code ]                │
├──────────────────────────────────────────┤
│ ( Biens à reconfirmer : 3 )  ▶           │
├──────────────────────────────────────────┤
│ ⌂Accueil ⌕Explorer (+) ✉Messages ☺Moi    │
└──────────────────────────────────────────┘
```

| Onglet | Contenu |
|--------|---------|
| Visites | Visites du jour et à venir, par agent ; saisie du code (E-IMMO-08) |
| Demandes | Messages et demandes de visite non traités |
| Biens | Liste des biens avec statut (publié, réservé, loué, masqué), statistiques par bien, bouton de reconfirmation |
| Équipe | Agents (jusqu'à 5 au MVP), affectation des biens (F-IMMO-AG-02) |

---

## E-IMMO-08 — Valider une visite (annonceur ou agent)

```text
┌──────────────────────────────────────────┐
│ ◀  Visite 10:30 · Merveille              │
├──────────────────────────────────────────┤
│ 2 ch. Moungali                           │
│                                          │
│ Demandez son code au visiteur :          │
│                                          │
│       [ _ ] [ _ ] [ _ ] [ _ ]            │
│                                          │
│ [      Valider la visite         ]       │
│                                          │
│ ────────── ou ──────────                 │
│ ( Le visiteur n'est pas venu )           │
│ ( Le bien n'est plus disponible )        │
├──────────────────────────────────────────┤
│ Vous recevrez 1 700 FCFA                 │
│ (2 000 - 15 % de commission Live)        │
└──────────────────────────────────────────┘
```

| Règle | Détail |
|-------|--------|
| « Le visiteur n'est pas venu » | Déclaration possible après l'heure du créneau ; le visiteur a 24 h pour contester, puis les frais sont versés (F-IMMO-VIS-06) |
| « Le bien n'est plus disponible » | Remboursement immédiat du visiteur ; l'annonce passe en « Masquée » ; pénalité de réputation |
